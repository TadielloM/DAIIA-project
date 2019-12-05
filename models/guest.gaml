/***
* Name: guest
* Author: Matteo and Marco <3
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model guest
import "base.gaml"

species Guest skills: [moving] {
	//Attributes
	list<string> music <- [];
	float generosity;
	float drunk <- 0.0;
	float happyness <- 0.0;
	float life_point <- 0.5;
	
	//For creativity
	// bool aggressive;
	// float hangry <- 0.0;
	
	//Needs
	int need_to_dance<-0;
	bool dancing<-true;
	int need_to_drink;
	bool drinking <-false;
	int wanna_walk;
	bool walking<-false;
	
	//Point to go
	point point_to_go;
	float probability_to_talk <- 0.71; //total probability to talk between two guest - 0.5
	
		
	reflex dance when: need_to_dance = 0 and (dancing and !drinking) {
		
		do goto target: point_to_go;
		need_to_drink <- need_to_drink -1;
		if(need_to_drink = 0){
			write(name+ " I go to drink");
			drinking <- true;
			dancing <- false;
			need_to_dance <- rnd(300);
			point_to_go <- Bar(rnd(number_of_bars-1)).location;
			write(point_to_go);
		}
	}
	
	reflex drink when: need_to_drink = 0 and (!dancing and drinking) {
		do goto target: point_to_go;
		need_to_dance <- need_to_dance -1;
		if(need_to_dance = 0){
			drinking <- false;
			if(flip(0.2)){
				write(name+ "I go to walk");
				
				walking <- true;
				wanna_walk <- rnd(100);
			}else{
				write(name+ "I go to dance");
				dancing <-true;
				need_to_drink <- rnd(300);
				point_to_go <- Stage(rnd(number_of_stages-1)).location;
			}
		}	
	}
	
	reflex walk when:!drinking and (!dancing and walking){
		wanna_walk <- wanna_walk -1;
		do wander;
		if(wanna_walk=0){
			write(name+ "I go to dance");		
			need_to_drink <- rnd(300);
			dancing <-true;
		}
	}
	
	
//	reflex wandering{
//    	do wander;
//  	}
  	
  	
  	
  	
	//visual aspect of agents
    aspect base{
       draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #red;  
    }
}




species Party parent: Guest{
	
	aspect base{
       draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #green;
    }
	
}

species Chill parent: Guest{
	string b <- "sono un b";
	aspect base{
       draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #blue;
      
    }
	
}

/* Insert your model definition here */

