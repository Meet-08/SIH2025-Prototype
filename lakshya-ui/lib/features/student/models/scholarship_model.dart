class ScholarshipModel {
  final int scholarshipId;
  final String scholarshipName;
  final String startingDate;
  final String endingDate;
  final double amount;
  final List<String> eligibility;
  final List<String> requiredDocuments;

  ScholarshipModel({
    required this.scholarshipId,
    required this.scholarshipName,
    required this.startingDate,
    required this.endingDate,
    required this.amount,
    required this.eligibility,
    required this.requiredDocuments,
  });

  factory ScholarshipModel.fromJson(Map<String, dynamic> json) {
    return ScholarshipModel(
      scholarshipId: json['scholarship_id'] as int,
      scholarshipName: json['scholarship_name'] as String,
      startingDate: json['starting_date'] as String,
      endingDate: json['ending_date'] as String,
      amount: (json['amount'] as num).toDouble(),
      eligibility: (json['eligibility'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      requiredDocuments: (json['required_documents'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scholarship_id': scholarshipId,
      'scholarship_name': scholarshipName,
      'starting_date': startingDate,
      'ending_date': endingDate,
      'amount': amount,
      'eligibility': eligibility,
      'required_documents': requiredDocuments,
    };
  }

  @override
  String toString() {
    return 'ScholarshipModel(scholarshipId: $scholarshipId, scholarshipName: $scholarshipName, startingDate: $startingDate, endingDate: $endingDate, amount: $amount, eligibility: $eligibility, requiredDocuments: $requiredDocuments)';
  }
}
