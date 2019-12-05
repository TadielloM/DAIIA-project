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
  geometry shape <- square(200#m); //size and dimension of the world
  
  int number_of_people<-10;
  int number_of_bars <- 2;
  int number_of_barmans;
  int number_of_guards <- 1;
  int number_giornalists <- 1;
  int number_of_red_cross <- 1;  
  
  int talk_distance<-2; //distance needed to talk with other guests asking informations
    
  init{
  	
    create guest number:number_of_people{
    	location <-{rnd(100),rnd(100),2.3};
    	//Attributi 
    }
   	
   	create bars number: number_of_bars {
   	
   	}
  }
} 

experiment myexperiment type:gui{  // inputs and output of simulation 
 parameter "number of people: " var: number_of_people;
 
  output{
    display mydisplay type:opengl {
      species guest aspect:base;
    }
  }
}