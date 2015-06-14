abstract class CollisionShape {}

class Box extends CollisionShape {
    double width, height;

    Box(this.width,this.height);
}

class Circle extends CollisionShape {
    double radius;

    Circle(this.radius);
}
