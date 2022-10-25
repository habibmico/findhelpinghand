from django.urls import path

from . import views

urlpatterns = [

    path('registrationWorker', views.registrationWorker, name='registrationWorker'),
    path('registration_homeowner', views.registration_homeowner, name='registration_homeowner'),
    path('login', views.login, name='login'),
    path('getall', views.getall, name='getall'),
    path('get_search_results', views.get_search_results, name='get_search_results'),
    path('getProfileInfo', views.getProfileInfo, name='getProfileInfo'),
    path('updateProfileInfoAddress', views.updateProfileInfoAddress,
         name='updateProfileInfoAddress'),
    path('updateProfileInfoWorkingHour', views.updateProfileInfoWorkingHour,
         name='updateProfileInfoWorkingHour'),
    path('deleteProfile', views.deleteProfile, name='deleteProfile'),
    path('createWorkOwner', views.createWorkOwner, name='createWorkOwner'),
    path('getallworkList', views.getallworkList, name='getallworkList'),
    path('removeWorkFromList', views.removeWorkFromList, name='removeWorkFromList'),
    path('writeReview', views.writeReview, name='writeReview'),
    path('getReview', views.getReview, name='getReview'),
    path('applyAppoint', views.applyAppoint, name='applyAppoint'),
    path('getAppointList', views.getAppointList, name='getAppointList'),
    path('acceptAppoint', views.acceptAppoint, name='acceptAppoint'),
    path('rejectAppoint', views.rejectAppoint, name='rejectAppoint'),
    path('getAppointedWorkers', views.getAppointedWorkers,
         name='getAppointedWorkers'),
]