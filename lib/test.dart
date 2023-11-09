main(){

  final a = A();
  C(a);
  B(a);
  a.run();

}
typedef VoidCallback = void Function();

class A{
  List<VoidCallback> callbackList = [];

  registerCallback(VoidCallback callback){
    callbackList.add(callback);
  }

  void run(){
    if(callbackList.isNotEmpty){
      for (var func in callbackList) {
        func();
      }
    }
  }
}

class B{
  B(A a){
    a.registerCallback(() =>print("B received"));
  }
}

class C{
  C(A a){
    a.registerCallback(() =>print("C received"));
  }

}