/***
* Name: Bars
* Author: matteo and marco
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model bars
import "base.gaml"

species Bar{
	
	int noise_level;
	
	reflex countpeople{
		list<agent> noise_people <- agents_at_distance(20);
		noise_level<-length(noise_people);
		//write("noise level: " + noise_level);
	}
	
	aspect base{
       draw square(10) color: #black;   
    }
}

species Barman skills:[fipa]{
	
	reflex whichdrink when:(!empty(proposes)){
		message whichdrink<- proposes[0];
		do propose message:whichdrink contents: drinklist.keys;	
	}
	
	
	aspect base{
       draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #purple;
      
    }
}


