/***
* Name: bars
* Author: matteo and marco
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model bars

species Bar{
	aspect base{
       draw square(2) color: #yellow;
      
    }
}
species barman{
	aspect base{
       draw obj_file("../includes/people.obj", 90::{-1,0,0}) size: 1.5 color: #purple;
      
    }
}


