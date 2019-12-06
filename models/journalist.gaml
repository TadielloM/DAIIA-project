/***
* Name: journalist
* Author: matteo e marco
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Journalist
import "base.gaml"

species Journalist skills:[moving]{
	
	list<int> music_journalist <- list_with(length(music_genres),0);
	list<string> music_partecipants <- [];
	list<int> happiness_journalist <- [];
	float median_happiness<-0.0;
	
	reflex getinfo{
		
		do wander;
	  	
	  	ask Party at_distance journalist_distance{  		
	  		add self.happiness to: myself.happiness_journalist; 	
	    }
	    ask Chill at_distance journalist_distance{
	  		add self.happiness to: myself.happiness_journalist; 	
	    }
	    median_happiness<-0.0;
	    if(length(happiness_journalist)>(1)){
		    loop i from:0 to: (length(happiness_journalist)-1){
		    	median_happiness<-median_happiness + happiness_journalist[i];	   	    
		    }
		    median_happiness<-median_happiness/(length(happiness_journalist));
		}	    
	    
	    
	    ask Party at_distance journalist_distance{    	
	    	bool already_interviewed<-false;
	    	loop j over:myself.music_partecipants{
	    		if(j=self.name){
	    			already_interviewed<-true;
	    			break;
	    		}
	    	}
	    	if(already_interviewed=false){
		    	loop k over:self.music{
			    		//write(self.music[0]);
			  		if(k='techno'){
			  			//write("entrato");
			  			myself.music_journalist[0]<-myself.music_journalist[0]+1;}
			  		if(k='pop'){
			  			myself.music_journalist[1]<-myself.music_journalist[1]+1;}
			  		if(k='rock'){
			  			myself.music_journalist[2]<-myself.music_journalist[2]+1;}
			  		if(k='edm'){
			  			myself.music_journalist[3]<-myself.music_journalist[3]+1;}
		    	}
	    	}
	    	
	  		add self.name to: myself.music_partecipants;
	    }	
	    
	    ask Chill at_distance journalist_distance{    	
	    	bool already_interviewed<-false;
	    	loop j over:myself.music_partecipants{
	    		if(j=self.name){
	    			already_interviewed<-true;
	    			break;
	    		}
	    	}
	    	if(already_interviewed=false){
		    	// loop over the music preferences
		    	//write(self.music[0]);
		  		if(self.music[0]='techno'){
		  			//write("entrato");
		  			myself.music_journalist[0]<-myself.music_journalist[0]+1;}
		  		if(self.music[0]='pop'){
		  			myself.music_journalist[1]<-myself.music_journalist[1]+1;}
		  		if(self.music[0]='rock'){
		  			myself.music_journalist[2]<-myself.music_journalist[2]+1;}
		  		if(self.music[0]='edm'){
		  			myself.music_journalist[3]<-myself.music_journalist[3]+1;}
	    	}
	    		
	  		add self.name to: myself.music_partecipants;
	    }   
	    
	    //write(music_journalist);	    
	}
	
		//visual aspect of agents
     aspect base{
       draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 3.0 color: #blue;
      
    }
	    	
}
