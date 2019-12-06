/***
* Name: guard
* Author: Marco and Matteo
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Guard
import "base.gaml"

species Jail{
	//visual aspect of agents
  	aspect base{
  		draw square(10) color:#black;
    	//draw obj_file("../includes/jail.obj", 90::{1,0,0}) size: 1 color:#black;
  	}
}

species Guard skills:[moving]{  
	
	
  	agent person_to_kill;
 
  	reflex catchperson when:(person_to_kill!=nil and !dead(person_to_kill)){
   
    	do goto target:(person_to_kill.location);
	    ask Guest at_distance talk_distance{
	      if(self = myself.person_to_kill){
	      	 myself.person_to_kill<-nil;
	         do goto target:(Jail[0].location);      
	      }
	    }
	}
  
  //visual aspect of agents
  aspect base{
    draw obj_file("../includes/deagle.obj", 90::{1,0,0}) size: 1 color:#black;
  }
}

