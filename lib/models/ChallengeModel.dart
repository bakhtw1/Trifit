class ChallengeModel {
  late final String type;
  late final int amount;
  late final int duration;
  late final DateTime start;
  late final DateTime end;
  ChallengeModel(this.type, this.amount, this.duration, this.start, this.end);
  
  @override
  String toString() {
    String challengeString = "Challenge type: "+ type + "\n";
    challengeString += "Goal Amount: " + amount.toString() + "\n";
    challengeString += "Goal Duration: " + duration.toString() + "\n";
    challengeString += "Start Date: " + start.toString() + "\n";
    challengeString += "End Date: " + start.toString();
    return challengeString;
  }

  Map<String, dynamic> toJson() {
    return {'type':type, 'amount':amount, 'duration':duration, 'start':start.toString(), 'end':end.toString()};
  }
}