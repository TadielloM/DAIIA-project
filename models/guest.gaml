/***
* Name: guest
* Author: Matteo and Marco <3
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model guest
import "base.gaml"

species Guest skills: [moving,fipa] {
	//Attributes
	list<string> music <- [];
	float generosity<-rnd(0.4);
	float drunk_level <- 0.0;
	float happiness <- 20.0;
	int life_points <- 100;
	
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
	
	//Position related variables
	point point_to_go;
	Bar   bar_where_i_am;
	Stage stage_where_i_am;
	
	float probability_to_talk <- 0.71; //total probability to talk between two guest - 0.5
	float accept_probability <- 0.5; //probability to accept proposes from same species (0.3 otherwise)
	
	//vairable needed for the execution
	int just_offered<-0; // For not offer everytime
	int just_compliment<-0;
	bool in_a_conversation <- false; 
	
	//TODO: Add to all that nothing is executed if we are in coma etilico	
	
	reflex decreaser {
		if(just_offered >0){
			just_offered <- just_offered-1;
		}
		if(just_compliment >0){
			just_compliment <- just_compliment-1;
		}
		if(drunk_level>0){
			if(cycle mod 100 = 0){
				drunk_level <- drunk_level -1;
			}
		}
		if (drunk_level<1){
			happiness <- happiness + 0.01;
		}
		if ( drunk_level>=1 and drunk_level < 1.4){
			happiness <- happiness - 0.02;
		}
		if ( drunk_level>=1.4){
			happiness <- 0.0;
		}
	}
	
	//Cycle of actions of typical guest go to dance -> go to drink -> go to dance or first go to walk and then to dance -> restart
	reflex dance when: need_to_dance = 0 and (dancing and !drinking) {
		
		do goto target: ({point_to_go.x-10+rnd(20),point_to_go.y-10+rnd(20),0});
		need_to_drink <- need_to_drink -1;
		if(need_to_drink = 0){
			//write(name+ " I go to drink");
			drinking <- true;
			dancing <- false;
			need_to_dance <- 200+rnd(600);
			bar_where_i_am <- Bar(rnd(number_of_bars-1)); 
			point_to_go <- bar_where_i_am.location;
		}
	}
	
	reflex drink when: need_to_drink = 0 and (!dancing and drinking) {
		do goto target: ({point_to_go.x-10+rnd(20),point_to_go.y-10+rnd(20),0});
		need_to_dance <- need_to_dance -1;
		if(need_to_dance = 0){
			drinking <- false;
			if(flip(0.2)){
				//write(name+ "I go to walk");
				walking <- true;
				wanna_walk <- 200+rnd(100);
			}else{
				//write(name+ "I go to dance");
				dancing <-true;
				need_to_drink <- 200+rnd(600);
				stage_where_i_am <-Stage(rnd(number_of_stages-1));
				point_to_go <- stage_where_i_am.location;
			}
		}	
	}
	
	reflex walk when:!drinking and (!dancing and walking){
		wanna_walk <- wanna_walk -1;
		do goto target: {rnd(dimension),rnd(dimension),rnd(10)};
		do wander;
		if(wanna_walk=0){
			//write(name+ "I go to dance");		
			need_to_drink <- 200+rnd(600);
			dancing <-true;
		}
	}
	
	
//	reflex wandering{
//    	do wander;
//  	}
  	
  	
  	
  	
	//visual aspect of agents
    aspect base{
    	if(drunk_level > 0.1){
    		draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #black;  
    	}else{
    		draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #red;  
    	}
       
    }
}




species Party parent: Guest{
	//Stage actions
	reflex talk_with_party_at_stage{
		if(flip(probability_to_talk)){
			ask Party at_distance talk_distance{
			
			}
		}
		
	}
	reflex talk_with_chill_at_stage {
		if(flip(probability_to_talk)){
			ask Chill at_distance talk_distance{
			
			}
		}
	}
	
	//_____________________Bar actions______________________
	reflex talk_with_party_at_bar when: drinking and (self distance_to bar_where_i_am)<5 and just_offered = 0 and in_a_conversation=false{
		//write(name + 'I talk with Party' + Party at_distance talk_distance);
		if(flip(generosity*probability_to_talk)){
			if (length(Party at_distance talk_distance)>0){
				write(name + 'I propose to drink to ' + Party at_distance talk_distance);
				in_a_conversation <-true;
				do start_conversation(to:: Party at_distance talk_distance, performative:: 'propose', contents :: ["Wanna Drink?"] );	
			}
		}else{
			just_offered <-100;
		}
	}
	
	reflex talk_with_chill_at_bar when: drinking and (self distance_to bar_where_i_am)<5 and just_offered = 0 and in_a_conversation=false{
		//write(name + 'I talk with Chill' + Chill at_distance talk_distance);
		if(flip(generosity*probability_to_talk)){
			if (length(Chill at_distance talk_distance) >0){
				write(name + 'I propose to drink to ' + Chill at_distance talk_distance);
				in_a_conversation <-true;
				do start_conversation(to:: Chill at_distance talk_distance, performative:: 'propose', contents :: ["Wanna Drink?"] );					
			}else{
				just_offered <-100;
			}
		}
	}
	
	// Accept refuse proposal of drink
	reflex accept_refuse_drink when: !empty(proposes){
		message m <- proposes[0];
		if(m.contents[0] = "Wanna Drink?"){
			write(species_of(m.sender));
			if(species_of(m.sender) = Party){
				accept_probability <-0.5;
			}
			if(flip(accept_probability) ){
				do accept_proposal message:m contents: ["Yeah sure!"];
				write(name+' I accept drink from '+ agent(m.sender).name);
				drunk_level <- drunk_level + drinklist['cocktail'];
			}else{
				do reject_proposal message:m contents: ["Naah"];
				write(name+' I refuse drink from '+ agent(m.sender).name);	
			}
		}
	}
	
	// Offer a drink 
	reflex offer_drink when: !empty(accept_proposals){
		message m <- accept_proposals[0];
		//write(name +" offered to "+ m.sender);
		just_offered <- 100;
		in_a_conversation <- false;
	}
	
	reflex rejected_drink when: !empty(reject_proposals){
		message m <- reject_proposals[0];
		//write(name +" rejected from "+ m.sender);
		if(flip(0.1)){
			happiness <- happiness -1;
		}		
		just_offered <- 100;
		in_a_conversation <- false;
	}
	
	//__________________WALKING ACTIONS_________________
	
	reflex talk_with_party_while_walking when: (self distance_to bar_where_i_am)>10 and (self distance_to stage_where_i_am)>10  {
		if(flip(probability_to_talk)){
			if (length(Party at_distance talk_distance) >0){
				write(name + 'I scream to ' + Party at_distance talk_distance);
				in_a_conversation <-true;
				do start_conversation(to:: Party at_distance talk_distance, performative:: 'inform', contents :: ["HEY PUSSYYY!","You are beautiful!"] );
				just_compliment <- 10;
			}
		}
	}
	
	reflex talk_with_chill_while_walking when: (self distance_to bar_where_i_am)>10 and (self distance_to stage_where_i_am)>10 and just_compliment=0{
		if(flip(probability_to_talk)){
			if (length(Chill at_distance talk_distance) >0){
				write(name + 'I scream to ' + Chill at_distance talk_distance);
				in_a_conversation <-true;
				do start_conversation(to:: Chill at_distance talk_distance, performative:: 'inform', contents :: ["HEY PUSSYYY!","You are beautiful!"] );
				just_compliment <- 10;
			}
		}
	}
	
	//Liked Compliment
	reflex compliment_management when: !empty(informs){
		message m <- informs[0];
		if(m.contents[0] = "HEY PUSSYYY!" or m.contents[0]= "CIAO!" ){
			write(name+ " compliment received by "+m.sender+ "the compliment was: "+m.contents);
			happiness <- happiness +3;
		}
		write(name + " Actual happiness " + happiness);
	}
	
	
	
	
	aspect base{
		if(drunk_level > 1){
    		draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #black;  
    	}else{
    		draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #green;  
    	}
    }
	
}

species Chill parent: Guest{
	
	reflex dance when: need_to_dance = 0 and (dancing and !drinking) {
		
		do goto target: ({ flip(0.5)? point_to_go.x-10+rnd(20) : point_to_go.x+10-rnd(20) , point_to_go.y-10,0});
		need_to_drink <- need_to_drink -1;
		if(need_to_drink = 0){
			//write(name+ " I go to drink");
			drinking <- true;
			dancing <- false;
			need_to_dance <- 200+rnd(600);
			bar_where_i_am <- Bar(rnd(number_of_bars-1)); 
			point_to_go <- bar_where_i_am.location;
		}
	}
	
	
	//Bar actions
	reflex talk_with_party_at_bar when: drinking and (self distance_to bar_where_i_am)<5 and just_offered = 0 and in_a_conversation=false{
		//write(name + 'I talk with Party' + Party at_distance talk_distance);
		if(flip(generosity*probability_to_talk)){
			if (length(Party at_distance talk_distance)>0){
				write(name + 'I propose to drink to ' + Party at_distance talk_distance);
				in_a_conversation <-true;
				do start_conversation(to:: Party at_distance talk_distance, performative:: 'propose', contents :: ["Wanna Drink?"] );	
			}
		}else{
			just_offered <-100;
		}
	}
	
	reflex talk_with_chill_at_bar when: drinking and (self distance_to bar_where_i_am)<5 and just_offered = 0 and in_a_conversation=false{
		//write(name + 'I talk with Chill' + Chill at_distance talk_distance);
		if(flip(generosity*probability_to_talk)){
			if (length(Chill at_distance talk_distance) >0){
				write(name + 'I propose to drink to ' + Chill at_distance talk_distance);
				in_a_conversation <-true;
				do start_conversation(to:: Chill at_distance talk_distance, performative:: 'propose', contents :: ["Wanna Drink?"] );					
			}else{
				just_offered <-100;
			}
		}
	}
	
	// Accept refuse proposal of drink
	reflex accept_refuse_drink when: !empty(proposes){
		message m <- proposes[0];
		if(m.contents[0] = "Wanna Drink?"){
			if(species_of(m.sender) = Party){
				accept_probability <-0.3;
			}
			if(flip(accept_probability) and (drunk_level < 0.8)){
				do accept_proposal message:m contents: ["Yeah why not?"];
				//write(name+' I accept drink from '+ agent(m.sender).name);
				drunk_level <- drunk_level + drinklist['beer'];
			}else{
				do reject_proposal message:m contents: ["No, thank you"];
				//write(name+' I refuse drink from '+ agent(m.sender).name);			
			}
		}
	}
	
	// Offer a drink 
	reflex offer_drink when: !empty(accept_proposals){
		message m <- accept_proposals[0];
		//write(name +" offered to "+ m.sender);
		just_offered <- 100;
		in_a_conversation <- false;
	}
	
	reflex offer_drink when: !empty(reject_proposals){
		message m <- reject_proposals[0];
		//write(name +" rejected from "+ m.sender);
		just_offered <- 100;
		in_a_conversation <- false;
	}
	
	
	//__________________WALKING ACTIONS_________________
	
	reflex talk_with_party_while_walking when: (self distance_to bar_where_i_am)>10 and (self distance_to stage_where_i_am)>10  {
		if(flip(probability_to_talk)){
			if (length(Party at_distance talk_distance) >0){
				write(name + 'I say to ' + Party at_distance talk_distance);
				in_a_conversation <-true;
				do start_conversation(to:: Party at_distance talk_distance, performative:: 'inform', contents :: ["CIAO!","You are beautiful!"] );
				just_compliment <- 10;
			}
		}
	}
	
	reflex talk_with_chill_while_walking when: (self distance_to bar_where_i_am)>10 and (self distance_to stage_where_i_am)>10 and just_compliment=0{
		if(flip(probability_to_talk)){
			if (length(Chill at_distance talk_distance) >0){
				write(name + 'I say to ' + Chill at_distance talk_distance);
				in_a_conversation <-true;
				do start_conversation(to:: Chill at_distance talk_distance, performative:: 'inform', contents :: ["CIAO!","You are beautiful!"] );
				just_compliment <- 10;
			}
		}
	}
	
	//Liked Compliment
	reflex compliment_management when: !empty(informs){
		message m <- informs[0];
		if(m.contents[0] = "HEY PUSSYYY!"){
			write(name+ " harassement received by "+m.sender+ "the compliment was: "+m.contents);
			happiness <- happiness -3;
		}else if(m.contents[0]= "CIAO!"){
			write(name+ " compliment received by "+m.sender+ "the compliment was: "+m.contents);
			happiness <- happiness +5;
		}
		write(name + " Actual happiness" + happiness);
	}
	
	
	
	aspect base{
       if(drunk_level > 1){
    		draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #black;  
    	}else{
    		draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #blue;
        }
    }
	
}

/* Insert your model definition here */

