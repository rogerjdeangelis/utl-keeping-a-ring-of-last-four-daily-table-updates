Keeping a ring of last four daily table updates

github
https://tinyurl.com/wf9ntvj
https://github.com/rogerjdeangelis/utl-keeping-a-ring-of-last-four-daily-table-updates

related to
https://tinyurl.com/swfwedo
https://communities.sas.com/t5/SAS-Programming/Select-only-updated-records-and-load-the-updated-records-in-SQL/m-p/637531

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

proc datasets lib=work kill;
run;quit;

* prime the ring this is a base not interested in this one;
data rolling_4_day_weight_loss(genmax=4);
  retain date 'This is Tue Jan 31, 2020';
  weight_lbs=220;
run;quit;

data rolling_4_day_weight_loss;
  retain date 'This is Wed Feb 1, 2020 ';
  weight_lbs=219;
run;quit;

data rolling_4_day_weight_loss;
  retain date 'This is Thu Feb 2, 2020 ';
  weight_lbs=216;
run;quit;

data rolling_4_day_weight_loss;
  retain date 'This is Fri Feb 3, 2020 ';
  weight_lbs=213;
run;quit;

proc contents data=work._all_;
run;quit;

data have;
   retain table;
   set
     rolling_4_day_weight_loss(gennum=0)  * how to access weights;
     rolling_4_day_weight_loss(gennum=-1)
     rolling_4_day_weight_loss(gennum=-2)
     rolling_4_day_weight_loss(gennum=-3)
    indsname=fro;
    if index(fro,"#")>0 then  table=scan(fro,2,"'#");
    else table=fro;
    day=-(_n_-1);
run;quit;

/*
WORK.HAVE total obs=4
                                                           WEIGHT_
              TABLE                      DATE                LBS      DAY

  ROLLING_4_DAY_WEIGHT_LOSS     This is Fri Feb 3, 2020      213        0  * most recent;
  ROLLING_4_DAY_WEIGHT_LOSS     This is Thu Feb 2, 2020      216       -1
  ROLLING_4_DAY_WEIGHT_LOSS     This is Wed Feb 1, 2020      219       -2
  ROLLING_4_DAY_WEIGHT_LOSS     This is Tue Jan 31, 202      220       -3
*/

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

RULE

  Remove table with Jan 31,2010 and make Feb th the most recent

 WORK.WANT total obs=4

                                                           WEIGHT_
             TABLE                       DATE                LBS      DAY

   ROLLING_4_DAY_WEIGHT_LOSS    This is Sun Feb 4, 2020      211        0     * new most recent;
   ROLLING_4_DAY_WEIGHT_LOSS    This is Fri Feb 3, 2020      213       -1
   ROLLING_4_DAY_WEIGHT_LOSS    This is Thu Feb 2, 2020      216       -2
   ROLLING_4_DAY_WEIGHT_LOSS    This is Wed Feb 1, 2020      219       -3
                                                                              * Jan 31 is removed;
*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;

* add todays weight;

data rolling_4_day_weight_loss;
  retain date 'This is Sun Feb 4, 2020 ';
  weight_lbs=211;
run;quit;

data want;
   retain table ;
   set
     rolling_4_day_weight_loss(gennum=0)   * This is how you get the history of weight change;
     rolling_4_day_weight_loss(gennum=-1)
     rolling_4_day_weight_loss(gennum=-2)
     rolling_4_day_weight_loss(gennum=-3)
    indsname=fro;
    if index(fro,"#")>0 then  table=scan(fro,2,"'#");
    else table=scan(fro,2,'.');;
    day=-(_n_-1);
run;quit;


