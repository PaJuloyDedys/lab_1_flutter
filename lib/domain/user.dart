class User {
  const User({
    required this.email,
    required this.name,
    required this.hash,
    this.bio,
  });

  final String email;
  final String name;
  final String hash;
  final String? bio;

  User copyWith({String? name, String? bio}) => User(
    email: email,
    name: name ?? this.name,
    hash: hash,
    bio: bio ?? this.bio,
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'hash': hash,
    'bio': bio,
  };

  factory User.fromJson(Map<String, dynamic> j) => User(
    email: j['email'] as String,
    name: j['name'] as String,
    hash: j['hash'] as String,
    bio: j['bio'] as String?,
  );
}
