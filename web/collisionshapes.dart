abstract class CollisionShape {}

class Box extends CollisionShape {
    double width, height;

    Box(this.width,this.height);
}
