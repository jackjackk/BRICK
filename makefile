### ADMIN ###

SHELL := /bin/bash

RSYNC := /usr/bin/rsync -avzP --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r --checksum
ERSYNC := $(RSYNC) --exclude=.git --exclude-from=.gitignore
BASENAME := $$(basename $$(pwd))
RESDIR := results/

sync:
	$(ERSYNC) ./ acid:$(BASENAME)/

res:
	mkdir -p tmp
	$(RSYNC) --partial-dir=tmp "acid:$(BASENAME)/results/*.rds" $(RESDIR)

scratch:
	mkdir -p $(HOME)/scratch/$(BASENAME)
	rm -fv scratch
	ln -s $(HOME)/scratch/$(BASENAME) scratch


results:
	mkdir -p $(HOME)/group/$(BASENAME)
	rm -fv results
	ln -s $(HOME)/group/$(BASENAME) results

init: scratch results

### RUN ###

R := /usr/bin/Rscript --vanilla
MCMC := cd $(HOME)/$(BASENAME)/calibration && $(R) BRICK_calib_driver.R -n 10000000 -N 4
MCMC_TEST := cd $(HOME)/$(BASENAME)/calibration && $(R) BRICK_calib_driver.R -n 10000 -N 2

test:
	cd calibration && Rscript --vanilla BRICK_calib_driver.R -n 10000 -N 2

test_runs: 
	$(MCMC_TEST) -d 1 
	$(MCMC_TEST) -z 1900 -Z 1929 -d 1
	$(MCMC_TEST) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 
	$(MCMC_TEST) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f giss
	$(MCMC_TEST) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss
	$(MCMC_TEST) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2015 -f giss

clean:
	rm -v scratch/*.rds 

all_runs:
	for X in {default,urban_z1900,urban_t1880,giss_T2009,giss_T2011,giss_T2015}; do qmake $${X} 4 16; done

1880_runs:
	for X in {urban_t1880,giss_T2009,giss_T2011,giss_T2015}; do qmake $${X} 4 16; done

1850_runs:
	for X in {default,urban_z1900}; do qmake $${X} 4 16; done

default:
	$(MCMC)

urban_z1900:
	$(MCMC) -z 1900 -Z 1929

urban_t1880:
	$(MCMC) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 

giss_T2009:
	$(MCMC) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f giss

giss_T2011:
	$(MCMC) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss

giss_T2015:
	$(MCMC) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2015 -f giss

giss_T2015_od10:
	$(MCMC) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2015 -f giss -u 10


### POST-PROCESS

RDS_FILES := $(wildcard $(RESDIR)*_mcmc_f*000000.rds)
RDS_GRTEST_FILES := $(patsubst %.rds,%_grtest.rds,$(RDS_FILES))
NC_FILES := $(patsubst %.rds,%_b5_t100_n1.nc,$(RDS_FILES))

nc: $(NC_FILES)

%_b5_t100_n1.nc: %.rds
	Rscript --vanilla calibration/rds2nc.R -t 100 -r $<

ncthin:
	Rscript --vanilla calibration/rds2nc.R -r 

grtest: $(RDS_GRTEST_FILES)

%_grtest.rds: %.rds
	Rscript --vanilla calibration/rds2grtest.R -r $<

move2data:
	mv -v $(HOME)/$(BASENAME)/scratch/*.rds $(HOME)/$(BASENAME)/results/
