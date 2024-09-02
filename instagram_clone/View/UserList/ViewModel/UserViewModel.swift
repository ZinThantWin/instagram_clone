import Foundation

final class UserViewModel : ObservableObject {
    @Published var userList : UserModelList?
    @Published var searchText : String  = ""
    
    func getAllUserProfiles()async {
        do{
            let response : UserModelList? = try await ApiService.shared.apiGetCall(from: ApiEndPoints.users, as: UserModelList.self,xNeedToken: true)
            await MainActor.run {[weak self] in
                self?.userList = response
            }
        }catch{
            superPrint("getting user feeds \(error)")}
    }
    
//    func deleteUser(id : String)async{
//        do{
//            let response :
//        }catch(
//        superPrint("error deleting user \(error)"))
//    }
    
    func deleteSelectedUser(at indexes : IndexSet){
        if let users = userList?.data {
            for index in indexes {
                var _ : UserModel = users[index]
                
            }
        }
    }
}
