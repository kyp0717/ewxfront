## Intro
Compute deep dive.  

The way to think about cloud computing in the most simplest form is:
Compute vs Storage

Essentially Compute have been decoupled from Storage.
If you are used to working on your laptop or even on a VM, this is a paradigm shift.
This design enable new capabilities which allow the operate in the way it does today.
We will go into a little more detail how design changes things.

My hope is to generate a greater appreciation for this design and through that
appreciation, it may guide, inspire and change the way you think about coding, experimentation
and ultimately implementation.  If you know how things are set up (or the architecture),
it may help you with better code design in the future.


1. Scaling:
* data volume can grow
* reduce data duplication
* computing power can grow
* allow for adjustment of resource based on usage

So the next obvious question is:
How do you get the data from storage to compute?
Who controls that transfer?
Sounds like a simple question but not really.
The answer depends on what kind of compute.
Believe it or not, this can be quite complex.
That's why Data Engineer exists.  



There is a dance that is happening.


In DBX, there is a third component:
Compute - Storage - code

2. Ephemeral Workload
