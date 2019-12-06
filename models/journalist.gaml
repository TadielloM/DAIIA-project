/***
* Name: journalist
* Author: matteo
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Journalist
import "base.gaml"

species Journalist skills:[moving]{
	
	list<int> music_journalist <- list_with(length(music_genres),0);
	list<float> happiness_journalist <- [];
	float median_happiness;
	
	reflex getinfo{
		
		do wander;
	  	
	  	ask Guest at_distance talk_distance{
	  		if(self.music="techno"){
	  			myself.music_journalist[0]<-myself.music_journalist[0]+1;}
	  		if(self.music="pop"){
	  			myself.music_journalist[1]<-myself.music_journalist[1]+1;}
	  		if(self.music="rock"){
	  			myself.music_journalist[2]<-myself.music_journalist[2]+1;}
	  		if(self.music="edm"){
	  			myself.music_journalist[3]<-myself.music_journalist[3]+1;}
	  		
	  		add self.happiness to: myself.happiness_journalist;
	    	
	    }
	    
	    loop i from:0 to: (length(happiness_journalist)-1){
	    	median_happiness<-median_happiness + happiness_journalist[i];	   	    
	    }
	    median_happiness<-median_happiness/length(happiness_journalist);
	    
	    //andranno plottate
	    //write(music_journalist);
	    //write(median_happiness)
	    
	}
	
		//visual aspect of agents
     aspect base{
       draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 3.0 color: #blue;
      
    }
	    	
}

