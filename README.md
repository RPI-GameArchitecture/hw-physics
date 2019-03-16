# ga2018-homework6
Sixth homework for Game Architecture.

This homework adds a physics directory to the source code.  In it you will find
the architecture for a rudimentary physics engine.  At a high level, it's
organized as follows:

* ga_rigid_bodies track velocity, mass, and transform of physics objects.
* A ga_rigid_body contains a ga_shape which defines its collidable shape.
* ga_physics_world contains and simulates all ga_rigid_bodies.
* ga_physics_component bridges a ga_rigid_body and ga_entity.
* ga_intersection.cpp contains several geometric intersection tests.

In this homework you are tasked with implementing some basic rigid body physics
and collision detection algorithms:

* Separating Axis Theorem
* Linear dynamics
* Collision response
* Angular dynamics (Bonus)

You will find the pieces of code you need to implement by searching for
"// TODO: Homework 6" comments in the depot.

When you're done, your code should pass the unit tests in
ga_intersection.tests.cpp (they are already called from main.cpp), as well as
simulate the motion and collisions between several boxes added to the scene.

## Separating Axis Theorem

This portion of the homework asks you to implement the separating axis test in
ga_intersection.cpp.  Some code has already been written for you to construct
bounding box objects that represent the shapes in world space.  You may ignore
the minimum penetration axis variables for the time being - you will need to
calculate them for the collision response portion.

When you've finished this portion of the assignment the unit tests should pass
and you should see several boxes in the scene that don't move.

## Linear Dynamics

This portion of the homework asks you to implement fourth-order Runge Kutta
numerical integration to drive your physics simulation.  You will code your
solution in step_linear_dynamics in ga_physics_world.cpp.

When you're done with this portion of the assignment the boxes in the scene
should move around.

## Collision Response

Finally, the last portion of the homework asks you to implement the linear
dynamics half of collision response.  You will code your solution in
resolve_collision in ga_physics_world.cpp.  Some code has already been written
for you to separate the objects that are colliding, otherwise the simulation
will not be stable.  Your job is to calculate the impulse and apply it to the
colliding objects.  Be sure to check if one of the objects is static.

You will need to return to your SAT implementation and modify it to also
calculate the axis of minimum penetration.

When you're done with this portion of the assignment the boxes should collide
with the floor and each other.  The box farthest to the left in the scene should
come to rest on the floor.  The two boxes in the middle should come to rest
stacked on top of each other.  Lastly the two boxes to the right should bounce
off of each other.

## Angular Dynamics (Bonus)

For 10 bonus points, you may implement the angular dynamics portion of the
physics simulation.

To do this, you will have to implement step_angular_dynamics in
ga_physics_world.cpp.  You will also have to modify your SAT code to calculate
the minimum penetration axis.  Code is already provided for you to obtain the
point of collision.  Lastly, you will have to modify your collision response
code to calculate objects' velocities at the point of collision, and apply the
impulse to both the linear and angular momentums.

When you complete the bonus, the boxes should spin away from each other after
they collide.

## Tips

* You can pause the simulation by pressing 'p'.  Pressing 'p' again will
resume the simulation.  While paused, you can step the simulation a single
frame by pressing 'n'.
* Remember that there are more than six axes to test for SAT of two oriented
bounding boxes in 3D.  The other axes are the nine cross products of the
boxes' half vectors.

Here's the shortest way to check if the projections of two objects
overlap in your SAT algorithm:

	bool overlap = !(min_a > max_b || max_a < min_b);

Here's code to calculate the amount of penetration along a particular
axis in your SAT algorithm:

	float penetration = ga_min((max_b - min_a), (max_a - min_b));

Here's code to convert the std::chrono delta time to a float value for
your numerical integration:

	float dt = std::chrono::duration_cast<std::chrono::duration<float>>(params->_delta_time).count();

Your collision resolution code needs to cover three cases:

	if (body_a->_flags & k_static)
	{
		// Compute impulse assuming rigid body a's mass is infinite.
	}
	else if (body_b->_flags & k_static)
	{
		// Compute impulse assuming rigid body b's mass is infinite.
	}
	else
	{
		// Compute impulse using both rigid bodies.
	}
