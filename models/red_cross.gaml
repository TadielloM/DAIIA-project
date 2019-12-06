/***
* Name: RedCross
* Author: matteo
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model RedCross
import "base.gaml"

species RedCross skills:[moving]{
	
	agent person_to_save;
	
	reflex savepeople when:(person_to_save!=nil and !dead(person_to_save)){
		
		do goto target:(person_to_save.location);
	    ask Guest at_distance talk_distance{
	      if(self = myself.person_to_save){
	      	 myself.person_to_save<-nil;
	         self.drunk_level<-0.0;
	         self.life_points<-100;      
	      }
	    }
	}
	
}


