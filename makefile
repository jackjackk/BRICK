### SETUP ###

NITER := 10000000
NTHIN := 1000

### ADMIN ###

SHELL := /bin/bash

RSYNC := /usr/bin/rsync -avzP --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r --checksum
ERSYNC := $(RSYNC) --exclude=.git --exclude-from=.gitignore
BASENAME := $$(basename $$(pwd))
RESDIR := results/

sync:
	$(ERSYNC) ./ acid:$(BASENAME)/

res:
	$(RSYNC) "acid:$(BASENAME)/results/*n1000000*.nc" $(RESDIR)

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

R := $$(which Rscript) --vanilla
MCMC := cd calibration && $(R) BRICK_calib_driver.R -n $(NITER) -N 4
MCMC1M := cd $(HOME)/$(BASENAME)/calibration && $(R) BRICK_calib_driver.R -n 1000000 -N 4
MCMC_TEST := cd calibration && $(R) BRICK_calib_driver.R -n 10000 -N 2

bounds: results/bounds.csv

results/bounds.csv:
	cd calibration && $(R) write_bounds.R -m none

test:
	cd calibration && Rscript --vanilla BRICK_calib_driver.R -n 10000 -N 2 -s lognorm -O gour

test_runs: 
	$(MCMC_TEST) -d 1 
	$(MCMC_TEST) -z 1900 -Z 1929 -d 1
	$(MCMC_TEST) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 
	$(MCMC_TEST) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f giss
	$(MCMC_TEST) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss
	$(MCMC_TEST) -z 1900 -Z 1929 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2015 -f giss

clean:
	rm -v scratch/*.rds 

## 16 runs

all_runs:
	for F in {urban,giss}; do for T in {hadcrut,giss}; do for CS in {inf,uninf}; do for OD in {4,10}; do qmake f$${F}_t$${T}_s$${CS}_o$${OD} 4 16; done; done; done; done

furban_thadcrut_sinf_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s inf -u 4
furban_thadcrut_sinf_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s inf -u 10
furban_thadcrut_suninf_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s uninf -u 4
furban_thadcrut_suninf_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s uninf -u 10
furban_tgiss_sinf_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s inf -u 4
furban_tgiss_sinf_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s inf -u 10
furban_tgiss_suninf_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s uninf -u 4
furban_tgiss_suninf_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s uninf -u 10
fgiss_thadcrut_sinf_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s inf -u 4
fgiss_thadcrut_sinf_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s inf -u 10
fgiss_thadcrut_suninf_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s uninf -u 4
fgiss_thadcrut_suninf_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s uninf -u 10
fgiss_tgiss_sinf_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s inf -u 4
fgiss_tgiss_sinf_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s inf -u 10
fgiss_tgiss_suninf_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s uninf -u 4
fgiss_tgiss_suninf_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s uninf -u 10

## Try higher OD bounds
high_od:
	for F in {urban,giss}; do for T in {hadcrut,giss}; do for CS in {inf,uninf}; do for OD in {50,100}; do qmake f$${F}_t$${T}_s$${CS}_o$${OD} 4 16; done; done; done; done

furban_thadcrut_sinf_o50:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s inf -u 50
furban_thadcrut_suninf_o50:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s uninf -u 50
furban_tgiss_sinf_o50:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s inf -u 50
furban_tgiss_suninf_o50:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s uninf -u 50
fgiss_thadcrut_sinf_o50:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s inf -u 50
fgiss_thadcrut_suninf_o50:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s uninf -u 50
fgiss_tgiss_sinf_o50:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s inf -u 50
fgiss_tgiss_suninf_o50:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s uninf -u 50

furban_thadcrut_sinf_o100:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s inf -u 100
furban_thadcrut_suninf_o100:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s uninf -u 100
furban_tgiss_sinf_o100:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s inf -u 100
furban_tgiss_suninf_o100:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s uninf -u 100
fgiss_thadcrut_sinf_o100:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s inf -u 100
fgiss_thadcrut_suninf_o100:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s uninf -u 100
fgiss_tgiss_sinf_o100:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s inf -u 100
fgiss_tgiss_suninf_o100:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s uninf -u 100

## Try lognorm S prior
slognorm:
	for F in {urban,giss}; do for T in {hadcrut,giss}; do for OD in {4,10}; do qmake slognorm_f$${F}_t$${T}_o$${OD} 4 16; done; done; done

slognorm_furban_thadcrut_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s lognorm -u 4
slognorm_furban_tgiss_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s lognorm -u 4
slognorm_fgiss_thadcrut_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s lognorm -u 4
slognorm_fgiss_tgiss_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s lognorm -u 4

slognorm_furban_thadcrut_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s lognorm -u 10
slognorm_furban_tgiss_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s lognorm -u 10
slognorm_fgiss_thadcrut_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s lognorm -u 10
slognorm_fgiss_tgiss_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s lognorm -u 10

## Try cheng ocean heat dataset
ocheng:
	for F in {urban,giss}; do for T in {hadcrut,giss}; do for OD in {4,10}; do qmake ocheng_f$${F}_t$${T}_o$${OD} 4 16; done; done; done

ocheng_furban_thadcrut_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s cauchy -u 4 -O cheng
ocheng_furban_tgiss_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s cauchy -u 4 -O cheng
ocheng_fgiss_thadcrut_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s cauchy -u 4 -O cheng
ocheng_fgiss_tgiss_o4:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s cauchy -u 4 -O cheng

ocheng_furban_thadcrut_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F hadcrut -s cauchy -u 10 -O cheng
ocheng_furban_tgiss_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2009 -f urban -F giss -s cauchy -u 10 -O cheng
ocheng_fgiss_thadcrut_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F hadcrut -s cauchy -u 10 -O cheng
ocheng_fgiss_tgiss_o10:
	$(MCMC) -H 150 -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss -s cauchy -u 10 -O cheng


## Previous exploratory runs

prev_all_runs:
	for X in {default,urban_z1900,urban_t1880,giss_T2009,giss_T2011,giss_T2015}; do qmake $${X} 4 16; done

1880_runs:
	for X in {urban_t1880,giss_T2009,giss_T2011,giss_T2015}; do qmake $${X} 4 16; done

1850_runs:
	for X in {default,urban_z1900}; do qmake $${X} 4 16; done

default:
	$(MCMC)

urban_z1900:
	$(MCMC) -z 1900 -Z 1929

giss_temp:
	$(MCMC_TEST) -z 1880 -Z 1900 -d ../brick_mcmc_furban_sinf_t18802009_z19001929_o4_n100000.rds -t 1880 -T 2011 -f giss -F giss

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


# h0
giss_T2011_h50:
	$(MCMC) -z 1900 -Z 1929 -d ../results/brick_mcmc_fgiss_sinf_t18802011_z19001929_o4_n10000000.rds -t 1880 -T 2011 -f giss -H 50 -u 10

giss_T2011_h100:
	$(MCMC) -z 1900 -Z 1929 -d ../results/brick_mcmc_fgiss_sinf_t18802011_z19001929_o4_n10000000.rds -t 1880 -T 2011 -f giss -H 100 -u 10

giss_T2011_h150:
	$(MCMC) -z 1900 -Z 1929 -d ../results/brick_mcmc_fgiss_sinf_t18802011_z19001929_o4_n10000000.rds -t 1880 -T 2011 -f giss -H 150 -u 10

h0_runs:
	for X in giss_T2011_h{50,100,150}; do qmake $${X} 4 16; done

giss_T2011_h50_od4:
	$(MCMC) -z 1900 -Z 1929 -d ../results/brick_mcmc_fgiss_sinf_t18802011_z19001929_o4_n10000000.rds -t 1880 -T 2011 -f giss -H 50 -u 4

giss_T2011_h100_od4:
	$(MCMC) -z 1900 -Z 1929 -d ../results/brick_mcmc_fgiss_sinf_t18802011_z19001929_o4_n10000000.rds -t 1880 -T 2011 -f giss -H 100 -u 4

giss_T2011_h150_od4:
	$(MCMC) -z 1900 -Z 1929 -d ../results/brick_mcmc_fgiss_sinf_t18802011_z19001929_o4_n10000000.rds -t 1880 -T 2011 -f giss -H 150 -u 4

h0_od4_runs:
	for X in giss_T2011_h{50,100,150}_od4; do qmake $${X} 4 16; done


### POST-PROCESS

RDS_FILES := $(wildcard $(RESDIR)*_mcmc_f*10000000.rds)
RDS_GRTEST_FILES := $(patsubst %.rds,%_grtest.rds,$(RDS_FILES))
NC_FILES := $(patsubst %.rds,%_b5_t1000_n1.nc,$(RDS_FILES))

RDS_FILES2 := $(wildcard $(RESDIR)*_mcmc_f*1000000.rds)
NC_FILES2 := $(patsubst %.rds,%_b5_t100_n1.nc,$(RDS_FILES2))

nc: $(NC_FILES) $(NC_FILES2)

%_b5_t1000_n1.nc: %.rds
	Rscript --vanilla calibration/rds2nc.R -t 1000 -r $<

%_b5_t100_n1.nc: %.rds
	Rscript --vanilla calibration/rds2nc.R -t 100 -r $<

nctest:
	Rscript --vanilla calibration/rds2nc.R -t 100 -r results/brick_mcmc_furban_sinf_t18802009_z19001929_o4_n1000000.rds

ncthin:
	Rscript --vanilla calibration/rds2nc.R -r 

grtest: $(RDS_GRTEST_FILES)

%_grtest.rds: %.rds
	Rscript --vanilla calibration/rds2grtest.R -r $<

move2data:
	mv -v $(HOME)/$(BASENAME)/scratch/*.rds $(HOME)/$(BASENAME)/results/
