from mongoengine import Document, StringField, EmailField, BooleanField, ObjectIdField, DateTimeField

class User(Document):
    fname= StringField(required=True)
    lname= StringField(required=True)
    email = EmailField(required=True, unique=True)
    phone_number = StringField(required=True, unique=True)
    password = StringField(required=True)
    user_type = StringField(default="user")
    joined_at = DateTimeField(required=True)
    is_verified = BooleanField(default=False)