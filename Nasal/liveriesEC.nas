#################################################################################
#		Lake of Constance Hangar												#
#		Boeing 707 for Flightgear												#
#		Copyright (C) 2013 M.Kraus												#	
#																				#
#		This program is free software: you can redistribute it and/or modify	#
#		it under the terms of the GNU General Public License as published by	#
#		the Free Software Foundation, either version 3 of the License, or		#
#		(at your option) any later version.										#
#																				#
#		This program is distributed in the hope that it will be useful,			#
#		but WITHOUT ANY WARRANTY; without even the implied warranty of			#
#		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the			#
#		GNU General Public License for more details.							#
#																				#
#		You should have received a copy of the GNU General Public License		#
#		along with this program.  If not, see <http://www.gnu.org/licenses/>.	#
#																				#
#		Every software has a developer, also free software. 					#
#		As a gesture of courtesy and respect, I would be delighted 				#		
#		if you contacted me before making any changes to this software. 		#
#		<info (at) marc-kraus.de> April, 2017									#
#################################################################################
aircraft.livery.init("Aircraft/707/Models/LiveriesEC");

# Not the best place but liveries are independent to the aircraft


var refuellingMsg = func{
		var state = getprop("systems/refuel/contact") or 0;
		var fuelWeight = getprop("consumables/fuel/total-fuel-kg") or 0;
		if (state) {
			if(fuelWeight < 60000){
				setprop("sim/multiplay/generic/int[12]", 1);
				settimer( refuellingMsg, 1.1);
			}else{
				setprop("sim/multiplay/generic/int[12]", 2);
			}
		}else{
			setprop("sim/multiplay/generic/int[12]", 0);
		}	 
}

setlistener( "systems/refuel/contact", func{ 
	refuellingMsg();
});