import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/utils/appColors.dart';
import '../../../../presentation/pages/dashboard/affiliation_dashboard/affiliationDasboard.dart';
import '../../../../presentation/pages/dashboard/common_screen_for_navigation.dart';
import '../../bloc/online_services_api_bloc.dart';
import '../../bloc/online_services_api_event.dart';
import '../../bloc/online_services_api_state.dart';
import '../../bloc/search_animation_bloc/search_animation_bloc.dart';
import '../../bloc/search_animation_bloc/update_search_animation_event.dart';
import '../../bloc/search_animation_bloc/update_search_animation_state.dart';
import '../../data/model/get_spec_class_list.dart';
import '../../data/model/get_specality_module.dart';
import '../../data/repositories/online_services_api.dart';
import '../online_services_widgets/online_services_widgets.dart';
import 'book_class_after_subscription.dart';
import 'book_class_before_subscription.dart';

class ClassSearch extends StatelessWidget {
  final OnlineServicesWidgets _onlineServicesWidgets = OnlineServicesWidgets();
  String selectedSpec;
  ClassSearch({Key key, this.selectedSpec}) : super(key: key);

  final GlobalKey<State<StatefulWidget>> dataKey =  GlobalKey();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              OnlineServicesApiBloc()..add(OnlineServicesApiEvent(data: "specialty")),
        ),
      ],
      child: BlocBuilder<OnlineServicesApiBloc, OnlineServicesState>(
        builder: (BuildContext ctx, OnlineServicesState specState) {
          return CommonScreenForNavigation(
            appBar: _buildAppBar(context),
            content: Column(
              children: <Widget>[
                _buildSearchBar(),
                if (specState is ApiCallLoadedState)
                  BlocProvider(
                    create: (BuildContext context) => SelectSpecialityBloc()
                      ..add(UpdatedSpecSelectedEvent(
                          selectedString: selectedSpec,
                          selectedAffi: selectedAffiliationfromuniquenameDashboard)),
                    child: BlocBuilder<SelectSpecialityBloc, SelectSpecState>(
                      builder: (BuildContext cntx, SelectSpecState selectedState) {
                        return selectedState is UpdateSelectSpecState
                            ? _buildSpecialtyList(
                                specState.classSpec.specialityList,
                                selectedState.selectedSpeCurrent == ""
                                    ? specState.classSpec.specialityList[0].specialityName
                                    : selectedState.selectedSpeCurrent,
                                selectedState.classList)
                            : SizedBox(
                                height: 75.h,
                                width: 80.w,
                                child: ListView.builder(
                                  itemCount: 4,
                                  itemBuilder: (context, int classListLen) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: Container(
                                        height: 25.h,
                                        width: 80.w,
                                        child: const Text("Loading"),
                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      title: const Text("Class List"),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 15),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        elevation: 2.0,
        child: TextField(
          // controller: TeleConsultationFunctionsAndVariables.searchDocController,
          onChanged: (String value) async {
            // searchLoader = true;
            // searchDoctorList.value = <DoctorModel>[];
            // debounce(() async {
            //   List<DoctorModel> ss = await TeleConsultationFunctionsAndVariables.searchDoc(
            //       query: value, searchTypes: <dynamic>["consultant_name"]);
            //   searchLoader = false;
            //   ss.removeWhere((DoctorModel element) => element.exclusiveOnly == true);
            //   searchDoctorList.value = ss;
            // });
          },
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              hintText: 'Search by Class',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildSpecialtyList(List<OnlineServicesSpecialityList> specialityList, String selectedSpec,
      List<SpecialityClassList> classList) {
    return Column(
      children: [
        Container(
          height: 7.4.h,
          color: Colors.transparent,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: specialityList.length,
            itemBuilder: (BuildContext context, int specLng) {
              return InkWell(
                onTap: () {
                  BlocProvider.of<SelectSpecialityBloc>(context).add(UpdatedSpecSelectedEvent(
                      selectedString: specialityList[specLng].specialityName,
                      selectedAffi: selectedAffiliationfromuniquenameDashboard));
                },
                child: _onlineServicesWidgets.ClassSpecTile(
                  specSelected: selectedSpec == specialityList[specLng].specialityName,
                  title: specialityList[specLng].specialityName,
                ),
              );
            },
          ),
        ),
        classList.isEmpty
            ? Padding(
                padding: EdgeInsets.only(left: 30.w, top: 20.h),
                child: Center(
                  child: SizedBox(
                    height: 10.h,
                    width: 80.w,
                    child: Text(
                      "No Class Found!",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            : Container(
                height: 62.h,
                color: Colors.transparent,
                child: ListView.builder(
                    itemCount: classList.length,
                    itemBuilder: (context, int classListLen) {
                      return _onlineServicesWidgets.classesWidget(classList[classListLen], context);
                    }),
              ),
      ],
    );
  }
}
