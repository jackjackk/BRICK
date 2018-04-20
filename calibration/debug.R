bound.lower.in = bound.lower
bound.upper.in = bound.upper
shape.in=shape.invtau
scale.in=scale.invtau
parameters.in=p0
parnames.in=parnames
forcing.in=forcing
l.project=l.project
rho.simple.in=NULL
sigma.simple.in=NULL
slope.Ta2Tg.in=1
intercept.Ta2Tg.in=0
mod.time=mod.time
ind.norm.data=ind.norm.data
ind.norm.sl=ind.norm
midx=midx.all
oidx=oidx.all
obs=obs.all
obs.err=obs.err.all
trends.te=trends.te
luse.brick=luse.brick
i0=i0
l.aisfastdy=l.aisfastdy


log.pri( parameters.in=p0,
         parnames.in=parnames,
         bound.lower.in=bound.lower,
         bound.upper.in=bound.upper,
         l.informed.prior.S=l.informed.prior.S,
         shape.in=shape.invtau,
         scale.in=scale.invtau)

parameters.in=c(2.8688224567261473,2.246947631244942,0.8579142026717708,-0.04006261561742587,-30.65734375942188,0.0010100773224583299,0.3973425627495554,0.7759112178489148,1.1846940138938897e-05,0.45248789933507966,0.46165281400658764,0.0021599393134754466,0.0013636050270552371,-2.2506775030954373,8.285824467310455,0.0006032287946636306,0.00014708974573477985,7.354135475269317,0.08007039742263129,1.092684261746644,0.43867276973728314,0.8722269665371288,0.00025077883232730273,0.7242539134377132,0.0002083943807905802,p0[26])

parameters.in=p0

log.lik(   parameters.in=parameters.in,
           parnames.in=parnames,
           forcing.in=forcing,
           l.project=l.project,
           rho.simple.in=NULL,
           sigma.simple.in=NULL,
           slope.Ta2Tg.in=1,
           intercept.Ta2Tg.in=0,
           mod.time=mod.time,
           ind.norm.data=ind.norm.data,
           ind.norm.sl=ind.norm,
           midx=midx.all,
           oidx=oidx.all,
           obs=obs.all,
           obs.err=obs.err.all,
           trends.te=trends.te,
           luse.brick=luse.brick,
           i0=i0,
           l.aisfastdy=l.aisfastdy)

parnames
