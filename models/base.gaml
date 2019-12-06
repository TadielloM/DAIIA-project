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
  int dimension<-200; 
  geometry shape <- square(dimension); //size and dimension of the world
  
  int number_of_people<-20;
  int number_of_bars <- 2;
  int number_of_stages <- 2;
  int number_of_barmans;
  int number_of_guards <- 1;
  int number_giornalists <- 1;
  int number_of_red_cross <- 1; 
  
  list music_genres <- ['techno','pop', 'rock', 'edm'];
  map<string,float> drinklist <-create_map(["beer","cocktail","whisky"],[0.2,0.5,0.9]);
  
  int talk_distance<-2; //distance needed to talk with other guests asking informations
  int journalist_distance<-10;
  
  init{
   	
   	create Bar{
   		location <- {180,180,0};
  		}
 	create Barman{
		location <- {180,180,2.3};
	}
    create Bar{
   		location <- {20,180,0};
   	}
   	create Barman{
   		location <- {20,180,2.3};
   	}
   	
   	create Guard{
   		location <-{rnd(200),rnd(200),4};
   		speed<-2.0;
   	}
   	
   	create Jail{
   		location<-{180,20,0};
   	}
   	
   	create Stage number: number_of_stages{
   		
   	}
   	
   	create Journalist{
  		location <-{rnd(dimension),rnd(dimension),2.7};
  	}
   	
    loop times:number_of_people{
    	create Party{
	    	location <-{rnd(dimension),rnd(dimension),2.3};
	    	need_to_drink <- 200+rnd(200);
	    	stage_where_i_am <- Stage(rnd(number_of_stages-1));
	    	bar_where_i_am <- Bar(rnd(number_of_stages-1));
	    	point_to_go <- stage_where_i_am.location;
	    	//Attributi 
	    	int i<-rnd(1,length(music_genres)-1);
	    	int j<-rnd(100);
	    	loop x from:j to:i+j{
	    		add music_genres[x mod length(music_genres)] to:music;
	    	}
	    }
    }
    loop times:number_of_people{
    	create Chill{
	    	location <-{rnd(dimension),rnd(dimension),2.3};
	    	need_to_drink <- 200+rnd(200);
	    	stage_where_i_am <- Stage(rnd(number_of_stages-1));
	    	bar_where_i_am <- Bar(rnd(number_of_stages-1));
	    	point_to_go <- stage_where_i_am.location;
	    	//Attributi 
	    	int i<-rnd(1,length(music_genres)-1);
	    	int j<-rnd(100);
	    	loop x from:j to:i+j{
	    		add music_genres[x mod length(music_genres)] to:music;
	    	}
	    }
    }
   	
   	
  }
} 

experiment myexperiment type:gui{  // inputs and output of simulation 
 parameter "number of people: " var: number_of_people;
 
 //DA AGGIUNGERE A MATTEO
  output{
  	layout #split;
    
    display chart_music { 
   		chart "Music Preferences" type: pie { 
      	data "Techno" value:Journalist[0].music_journalist[0] color:#yellow;
      	data "Pop" value:Journalist[0].music_journalist[1] color:#blue thickness: 5;
      	data "Rock" value:Journalist[0].music_journalist[2] color:#red thickness: 5;
      	data "Edm" value:Journalist[0].music_journalist[3] color:#green thickness: 5;
   		} 
   	} 
   	display chart_happiness_general{
   		chart "General Happiness" type: histogram {
   			loop i over:Party{
   				data i.name value:i.happiness;
   			}
   			loop i over:Chill{
   				data i.name value:i.happiness;
   			}
  		} 
	}
	display chart_happiness_journalist{
		chart "Happiness by Journalist" type:series{
			data "Happiness" value:Journalist[0].median_happiness color:#green;
		}
	}
	display mydisplay type:opengl {
      species Guest aspect:base;
      species Party aspect:base;
      species Chill aspect:base;
      species Bar   aspect:base;
      species Stage aspect:base;
      species Guard aspect:base;
      species Jail  aspect:base;
      species Journalist aspect:base;
    }
  }
}