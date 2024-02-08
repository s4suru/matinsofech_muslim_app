class HadithApiModel {
  String? hadithEnglish;
  String? hadithArabic;
  String? hadithBengali;
  String? checkStatus;
  String? hadithNo;
  String? id;
  String? thesequence;
  String? isActive;
  String? chapterId;
  String? bookId;
  String? publisherId;
  String? sectionId;
  String? statusId;
  String? topicName;
  String? rabiNameBn;
  String? rabiNameEn;

  HadithApiModel(
      {this.hadithEnglish,
        this.hadithArabic,
        this.hadithBengali,
        this.checkStatus,
        this.hadithNo,
        this.id,
        this.thesequence,
        this.isActive,
        this.chapterId,
        this.bookId,
        this.publisherId,
        this.sectionId,
        this.statusId,
        this.topicName,
        this.rabiNameBn,
        this.rabiNameEn});

  HadithApiModel.fromJson(Map<String, dynamic> json) {
    hadithEnglish = json['hadithEnglish'];
    hadithArabic = json['hadithArabic'];
    hadithBengali = json['hadithBengali'];
    checkStatus = json['checkStatus'];
    hadithNo = json['hadithNo'];
    id = json['id'];
    thesequence = json['thesequence'];
    isActive = json['isActive'];
    chapterId = json['chapterId'];
    bookId = json['bookId'];
    publisherId = json['publisherId'];
    sectionId = json['sectionId'];
    statusId = json['statusId'];
    topicName = json['topicName'];
    rabiNameBn = json['rabiNameBn'];
    rabiNameEn = json['rabiNameEn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hadithEnglish'] = this.hadithEnglish;
    data['hadithArabic'] = this.hadithArabic;
    data['hadithBengali'] = this.hadithBengali;
    data['checkStatus'] = this.checkStatus;
    data['hadithNo'] = this.hadithNo;
    data['id'] = this.id;
    data['thesequence'] = this.thesequence;
    data['isActive'] = this.isActive;
    data['chapterId'] = this.chapterId;
    data['bookId'] = this.bookId;
    data['publisherId'] = this.publisherId;
    data['sectionId'] = this.sectionId;
    data['statusId'] = this.statusId;
    data['topicName'] = this.topicName;
    data['rabiNameBn'] = this.rabiNameBn;
    data['rabiNameEn'] = this.rabiNameEn;
    return data;
  }
}