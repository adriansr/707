# Lake of Constance Hangar :: M.Kraus
# Avril 2013
# This file is licenced under the terms of the GNU General Public Licence V2 or later
################################ Reverser ####################################
setlistener("/instrumentation/mptcas/on", func(state) {
  var state = state.getBoolValue();  
  if(state) tcas();
}, 0, 1);

var tcas = func {

		var run = getprop("/instrumentation/mptcas/on") or 0;

		var pos_lat = getprop("/position/latitude-deg") or 0;
		var pos_lon = getprop("/position/longitude-deg") or 0;
		
		var our_pos = geo.aircraft_position();
		var my_hdg = getprop("/orientation/heading-deg") or 0;
		
		var display_factor = getprop("/instrumentation/mptcas/display-factor") or 0;
	
		# Multiplayer TCAS
	
		for (var n = 0; n < 20; n += 1) {
		
			var callsign = getprop("ai/models/multiplayer[" ~ n ~ "]/callsign") or 0;
	
			if (getprop("ai/models/multiplayer[" ~ n ~ "]/valid") and callsign and run) {
		
				var mp_lat = getprop("ai/models/multiplayer[" ~ n ~ "]/position/latitude-deg") or 0;
				var mp_lon = getprop("ai/models/multiplayer[" ~ n ~ "]/position/longitude-deg") or 0;
					
				var x = (mp_lon - pos_lon) * display_factor;
				var y = (mp_lat - pos_lat) * display_factor;			
				
				# What is our position to the mp?		
				var mp_pos 	= geo.Coord.new();
						mp_pos.set_latlon( mp_lat, mp_lon);
				var hdg_to_mp = our_pos.course_to(mp_pos);
				var distance = our_pos.distance_to(mp_pos) * 0.0005399568034557236; # to nautical miles
				var course_to_mp = 360 - geo.normdeg(my_hdg - hdg_to_mp); 
			  
				var display = distance * display_factor; # for the range of the selected mp-aircrafts
				
				var alt_ft = getprop("ai/models/multiplayer[" ~ n ~ "]/position/altitude-ft") or 0;
			  var tas_kt = getprop("ai/models/multiplayer[" ~ n ~ "]/velocities/true-airspeed-kt") or 0;
			  var t_code = getprop("ai/models/multiplayer[" ~ n ~ "]/instrumentation/transponder/transmitted-id") or 0;
			  var t_code = abs(t_code);
			  
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/dis-x", x);										# for the radar pos
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/dis-y", y);										# for the radar pos
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/callsign", callsign);					# only info
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/distance-nm", distance);			# only info		
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/course-to-mp",course_to_mp);	# only info
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/altitude-ft", alt_ft);				# only info
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/tas-kt", tas_kt);							# only info
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/id-code", t_code);						# only info
				
				# select object if in range of radar / 3.24 found by trial and error depends on range select knob
				if (display < 3.24){ 
					setprop("/instrumentation/mptcas/mp[" ~ n ~ "]/show", 1);
				}else{
					setprop("/instrumentation/mptcas/mp[" ~ n ~ "]/show", 0);				
				}
				
			}else{
			
				setprop("/instrumentation/mptcas/mp[" ~ n ~ "]/show", 0);		
			}
	
		}
	
	# AI TCAS
	
		for (var n = 0; n < 20; n += 1) {
		
			var callsign = getprop("ai/models/aircraft[" ~ n ~ "]/callsign") or 0;
	
			if (getprop("ai/models/multiplayer[" ~ n ~ "]/valid") and callsign and run) {
		
				var ai_lat = getprop("ai/models/aircraft[" ~ n ~ "]/position/latitude-deg") or 0;
				var ai_lon = getprop("ai/models/aircraft[" ~ n ~ "]/position/longitude-deg") or 0;

				var x = (ai_lon - pos_lon) * display_factor;
				var y = (ai_lat - pos_lat) * display_factor;			
				
				# What is our position to the ai?		
				var ai_pos 	= geo.Coord.new();
						ai_pos.set_latlon( ai_lat, ai_lon);
				var hdg_to_mp = our_pos.course_to(ai_pos);
				var distance = our_pos.distance_to(ai_pos) * 0.0005399568034557236; # to Nautical Miles
				var course_to_mp = 360 - geo.normdeg(my_hdg - hdg_to_mp); 
			  
				var display = distance * display_factor; # for the range of the selected ai-aircrafts
				
				var alt_ft = getprop("ai/models/aircraft[" ~ n ~ "]/position/altitude-ft") or 0;
			  var tas_kt = getprop("ai/models/aircraft[" ~ n ~ "]/velocities/true-airspeed-kt") or 0;
			  
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/dis-x", x);										# for the radar pos
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/dis-y", y);										# for the radar pos
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/callsign", callsign);					# only info
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/distance-nm", distance);			# only info		
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/course-to-mp",course_to_mp);	# only info
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/altitude-ft", alt_ft);				# only info
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/tas-kt", tas_kt);							# only info
				
				# select object if in range of radar / 3.24 found by trial and error depends on range select knob
				if (display < 3.24){ 
					setprop("/instrumentation/mptcas/ai[" ~ n ~ "]/show", 1);
				}else{
					setprop("/instrumentation/mptcas/ai[" ~ n ~ "]/show", 0);				
				}
				
			}else{
			
				setprop("/instrumentation/mptcas/ai[" ~ n ~ "]/show", 0);		
			}
	
		}
		
	if (run) settimer(tcas, 0.7);
	
}


   

