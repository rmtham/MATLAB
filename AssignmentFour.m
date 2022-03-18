year = [ 1980 1985 1990 1995 2000 2005 2010 ]';
airtime_music = [ 95 83 65 40 20 10 5 ]';
airtime_musicawards = [ 0 12 20 30 30 30 30 ]';
airtime_other = 100 - airtime_music - airtime_musicawards;

plot( year, airtime_music, '-oB' );
hold on;
plot( year, airtime_musicawards, '-VG' );
hold on;
plot( year, airtime_other, '--k' );

xlim( [ 1980 2010 ] )
ylim( [ 0 100 ] )
xlabel( 'Year' );
ylabel( '% of Airtime' );
title( 'MVT Through the Years' );
legend( 'Music Videos', 'Music Video Awards', 'Other', 'Location', 'NorthEast' );