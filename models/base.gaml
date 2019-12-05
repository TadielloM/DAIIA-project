/***
* Name: BasicModel
* Author: Marco Moletta, Matteo Tadiello
* Description: 
* Tags: Festival, BaseChallenge
***/

model BasicModel
import "guest.gaml"
import "bars.gaml"
import "stages.gaml"
import "red_cross.gaml"
import "journalist.gaml"
import "guard.gaml"

global {        // characteristics of the world 
  int dimension<-50; 
  geometry shape <- square(dimension#m); //size and dimension of the world
  
  int number_of_people<-2;
  int number_of_bars <- 2;
  int number_of_stages <- 2;
  int number_of_barmans;
  int number_of_guards <- 1;
  int number_giornalists <- 1;
  int number_of_red_cross <- 1;  
  
  list music_genres <- ['techno','pop', 'rock', 'edm'];
  
  int talk_distance<-2; //distance needed to talk with other guests asking informations
  
  init{
   	
   	create Bar number: number_of_bars {
   	
   	}
   	
   	create Stage number: number_of_stages{
   		
   	}
    
    create Party number:number_of_people{
    	location <-{rnd(dimension),rnd(dimension),2.3};
    	need_to_drink <- rnd(200);
    	point_to_go <- Stage(rnd(number_of_stages-1)).location;
    	//Attributi 
    }
    create Chill number:number_of_people{
    	location <-{rnd(dimension),rnd(dimension),2.3};
    	need_to_drink <- rnd(200);
    	point_to_go <-Stage(rnd(number_of_stages-1)).location;
    	
    	//Attributi 
    }
   	
  }
} 

experiment myexperiment type:gui{  // inputs and output of simulation 
 parameter "number of people: " var: number_of_people;
 
  output{
    display mydisplay type:opengl {
      species Guest aspect:base;
      species Party aspect:base;
      species Chill aspect:base;
      species Bar   aspect:base;
      species Stage aspect:base;
    }
  }
}