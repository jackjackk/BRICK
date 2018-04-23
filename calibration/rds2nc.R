library("optparse")

option_list = list(
  make_option(c("-r", "--rdsfile"), type="character", default="~/CloudStation/psu/projects/brick/doeclim_mcmc_e2011_t1929_o4_n2000000.rds", help="rds file"),
  make_option(c("-t", "--thin"), type="integer", default=1000, help="keep one every N samples"),
  make_option(c("-b", "--burnin"), type="integer", default=5, help="percentage to burn"),
  make_option(c("-n", "--nchain"), type="integer", default=1, help="number of chains")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

#rdsfile = "results/doeclim_mcmc_ftony_e2009_t1929_o4_n10000000.rds"
parnames   =c("S", "kappa.doeclim", "alpha.doeclim", "T0", "H0", "beta0", "V0.gsic", "n", "Gs0", "a.te", "b.te", "invtau.te", "TE0", "a.simple", "b.simple", "alpha.simple", "beta.simple", "V0", "sigma.T", "sigma.H", "rho.T", "rho.H", "sigma.gsic", "rho.gsic", "sigma.simple", "rho.simple")

amcmc.par1 = readRDS(opt$rdsfile)
#amcmc.par1 = readRDS(rdsfile)

niter.mcmc = amcmc.par1[[1]]$n.sample
nnode.mcmc <- opt$nchain #length(amcmc.par1)



burnin = round(niter.mcmc*opt$burnin/100)				# how much to remove for burn-in
ifirst = burnin

library(coda)
#trace = amcmc.par1[[1]]$samples[(ifirst+1):niter.mcmc,]
#acf(trace[seq(1,nrow(trace),9999)])
thin = opt$thin-1

chains_burned <- vector('list', nnode.mcmc)
for (m in 1:nnode.mcmc) {
  trace <- amcmc.par1[[m]]$samples[(ifirst+1):niter.mcmc,1:length(parnames)]
  chains_burned[[m]] <- trace[seq(1, nrow(trace), thin + 1), ]
}


parameters.posterior <- chains_burned[[1]]
#covjump.posterior <- amcmc.par1[[1]]$cov.jump
if (nnode.mcmc>1) {
for (m in 2:nnode.mcmc) {
  parameters.posterior <- rbind(parameters.posterior, chains_burned[[m]])
}
}

## Get maximum length of parameter name, for width of array to write to netcdf
## this code will write an n.parameters (rows) x n.ensemble (columns) netcdf file
## to get back into the shape BRICK expects, just transpose it
lmax=0
for (i in 1:length(parnames)){lmax=max(lmax,nchar(parnames[i]))}

library(ncdf4)
dim.parameters <- ncdim_def('n.parameters', '', 1:ncol(parameters.posterior), unlim=FALSE)
dim.name <- ncdim_def('name.len', '', 1:lmax, unlim=FALSE)
dim.ensemble <- ncdim_def('n.ensemble', 'ensemble member', 1:nrow(parameters.posterior), unlim=TRUE)
parameters.var <- ncvar_def('BRICK_parameters', '', list(dim.parameters,dim.ensemble), -999)
parnames.var <- ncvar_def('parnames', '', list(dim.name,dim.parameters), prec='char')
tmpfile <- sub('\\.rds$', sprintf('_b%d_t%d_n%d.nc.tmp', opt$burnin, opt$thin, opt$nchain), opt$rdsfile)
outnc <- nc_create(tmpfile , list(parameters.var,parnames.var))
ncvar_put(outnc, parameters.var, t(parameters.posterior))
ncvar_put(outnc, parnames.var, parnames)
nc_close(outnc)

file.rename(from=tmpfile,to=sub('\\.nc.tmp$', '.nc', tmpfile))
