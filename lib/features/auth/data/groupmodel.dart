class GroupModel {
  final String id;
  final String groupName;
  final String createdBy;
  final List members;
  final String joinCode;
  final int turnIndex;

  GroupModel({
    required this.id,
    required this.groupName,
    required this.createdBy,
    required this.members,
    required this.joinCode,
    required this.turnIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "groupName": groupName,
      "createdBy": createdBy,
      "members": members,
      "joinCode": joinCode,
      "turnIndex": turnIndex,
    };
  }
}
