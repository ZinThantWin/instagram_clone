import Foundation

struct EditProfileDetailModel {
    var title, value, shortDes :String
    var type :EditDetailEnum
}



func  SampleEditProfileDetailModel ()-> EditProfileDetailModel {
    return EditProfileDetailModel(title: "", value: "", shortDes: "", type: .name)
}
