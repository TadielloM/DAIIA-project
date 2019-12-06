/***
* Name: stages
* Author: matteo
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model stages
import "base.gaml"

species Stage skills: [fipa]{
	
	string concert_genre;
	
	reflex change_concert when: (cycle mod 500 = 2){
		//write(name+ music_genres[rnd(length(music_genres)-1)]);
		concert_genre <- music_genres[rnd(length(music_genres)-1)];
		list partecipants <- [];
		loop p over:Party{
			add p to: partecipants;
		}
		loop c over:Chill{
			add c to: partecipants;
		}
		
		//write(partecipants);
		
		do start_conversation(to:: partecipants, performative:: 'inform', contents :: [concert_genre] );
	}
	
	aspect base{
       draw square(10) color: #orangered;
    }
}

/* Insert your model definition here */

