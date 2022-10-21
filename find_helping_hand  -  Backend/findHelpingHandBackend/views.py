import base64
from django.shortcuts import render
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
from collections import namedtuple
import json

# Create your views here.
from django.http import FileResponse, HttpResponse, JsonResponse
from PIL import Image
from io import BytesIO  # from io import StringIO.
import PIL.Image
import io


@csrf_exempt
def registration_homeowner(request):
    if request.method == 'POST':
        name = request.POST.get("name", False)
        address = request.POST.get("address", False)
        phone = request.POST.get("phone", False)
        password = request.POST.get("password", False)
        image = request.FILES.get('image', False)
        myimage1 = image.read()
        myimage = base64.b64encode(myimage1)

        with connection.cursor() as cursor_1:
            cursor_1.execute("INSERT INTO homeowner(name,address,phone,profilePic, password) VALUES ('"+str(
                name) + "' ,'"+str(address) + "','"+str(phone) + "',%s,'"+str(password) + "' )", (myimage, ))
            connection.commit()

    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def registrationWorker(request):
    if request.method == 'POST':
        name = request.POST.get("name", False)
        address = request.POST.get("address", False)
        phone = request.POST.get("phone", False)
        workingHour = request.POST.get("workingHour", False)
        password = request.POST.get("password", False)
        image = request.FILES.get('image', False)
        myimage1 = image.read()
        myimage2 = base64.b64encode(myimage1)

        with connection.cursor() as cursor_1:
            cursor_1.execute("INSERT INTO worker_table(name,address,phone,workingHour,profilePic,password) VALUES ('"+str(
                name) + "' ,'"+str(address) + "','"+str(phone) + "','"+str(workingHour) + "',%s,'"+str(password) + "' )", (myimage2, ))
            connection.commit()
    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def login(request):
    if request.method == 'POST':
        name = request.POST.get("name", False)
        password = request.POST.get("password", False)
        userType = request.POST.get("userType", False)
        if userType == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "select Name, Address, Phone, profilePic, Password from homeowner where name='"+str(name) + "'")
                row1 = cursor_1.fetchone()
            if row1 == None:
                data = {"message": "Wrong"}
                result = []
                result.append(data)
                json_data = json.dumps(result)
                return HttpResponse(json_data, content_type="application/json")
            else:
                if name == row1[0] and password == row1[4]:
                    # data = {"message": "Success"}
                    result = []
                    keys = ('name', 'address', 'phone',
                            'profilePic', 'password')

                    im = row1[3]
                    base64_string = im.decode('utf-8')
                    y = list(row1)
                    y[3] = base64_string
                    row1 = tuple(y)
                    result.append(dict(zip(keys, row1)))
                    json_data = json.dumps(result)
                    return HttpResponse(json_data, content_type="application/json")
                else:
                    data = {"message": "Wrong"}
                    result = []
                    result.append(data)
                    json_data = json.dumps(result)
                    return HttpResponse(json_data, content_type="application/json")

        else:
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "select Name, Address, Phone, profilePic, workingHour, Password from worker_table where name='"+str(name)+"'")
                row1 = cursor_1.fetchone()
                # print(row1)

            if row1 == None:
                data = {"message": "Wrong"}
                result = []
                result.append(data)
                json_data = json.dumps(result)
                return HttpResponse(json_data, content_type="application/json")
            else:
                if name == row1[0] and password == row1[5]:
                    # data = {"message": "Success"}
                    result = []
                    keys = ('name', 'address', 'phone',
                            'profilePic', 'workingHour', 'Password')
                    im = row1[3]
                    base64_string = im.decode('utf-8')
                    y = list(row1)
                    y[3] = base64_string
                    row1 = tuple(y)
                    result.append(dict(zip(keys, row1)))
                    json_data = json.dumps(result)
                    return HttpResponse(json_data, content_type="application/json")
                else:
                    data = {"message": "Wrong"}
                    result = []
                    result.append(data)
                    json_data = json.dumps(result)
                    return HttpResponse(json_data, content_type="application/json")

    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def getall(request):
    if request.method == 'POST':
        userType = request.POST.get("userType", False)
        userPhone = request.POST.get("userPhone", False)
        status = 'Enable'
        if userType == "Worker":
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "select name,address,phone,profilePic from homeowner")
                row1 = cursor_1.fetchall()
            if row1 == None:
                json_data = {"message": "Wrong"}
                return HttpResponse(json_data, content_type="application/json")
            else:
                result = []
                keys = ('name', 'address', 'phone', 'profilePic')
                for row in row1:
                    im = row[3]
                    base64_string = im.decode('utf-8')
                    y = list(row)
                    y[3] = base64_string
                    row = tuple(y)
                    result.append(dict(zip(keys, row)))
                json_data = json.dumps(result)
                # print(json_data)
                return HttpResponse(json_data, content_type="application/json")
        else:
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "select name,address,phone,workingHour,profilePic from worker_table")
                # cursor_1.execute("select name,address,phone,workingHour,profilePic from worker_table inner join appointtableowner on worker_table.phone != appointtableowner.WorkerPhone where OwnerPhone='"+str(userPhone)+"' and status = '"+str(status) + "'")
                row1 = cursor_1.fetchall()
                # print(row1)

            if row1 == None:
                json_data = {"message": "Wrong"}
                return HttpResponse(json_data, content_type="application/json")
            else:
                result = []
                keys = ('name', 'address', 'phone',
                        'workingHour', 'profilePic')
                for row in row1:
                    im = row[4]
                    base64_string = im.decode('utf-8')
                    y = list(row)
                    y[4] = base64_string
                    row = tuple(y)
                    result.append(dict(zip(keys, row)))
                json_data = json.dumps(result)
                # print(json_data)
                return HttpResponse(json_data, content_type="application/json")


@csrf_exempt
def get_search_results(request):
    if request.method == 'POST':
        search_item = request.POST.get("search_item", False)
        with connection.cursor() as cursor_1:
            cursor_1.execute(
                "select name,address,phone,workingHour,profilePic from worker_table where phone='"+str(search_item) + "'")
            row1 = cursor_1.fetchall()

            if row1 == None:
                json_data = {"message": "Wrong"}
                return HttpResponse(json_data, content_type="application/json")
            else:
                # if name==row1[0] and password == row1[1]:
                #     data = {"message":"Success"}
                #     print(data)

                # else:
                result = []
                keys = ('name', 'address', 'phone',
                        'workingHour', 'profilePic')
                for row in row1:
                    im = row[4]
                    base64_string = im.decode('utf-8')
                    y = list(row)
                    y[4] = base64_string
                    row = tuple(y)
                    result.append(dict(zip(keys, row)))
                json_data = json.dumps(result)
                # print(json_data)
                return HttpResponse(json_data, content_type="application/json")


@csrf_exempt
def getProfileInfo(request):
    if request.method == 'POST':
        name = request.POST.get("name", False)
        type = request.POST.get("type", False)
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "select name,address,phone,profilePic from homeowner where name='"+str(name) + "'")
                row1 = cursor_1.fetchone()

                if row1 == None:
                    json_data = {"message": "Wrong"}
                    return HttpResponse(json_data, content_type="application/json")
                else:
                    im = row1[3]
                    # binary_data = base64.b64decode(im)
                    base64_string = im.decode('utf-8')

                    # Cimage = Image.open(io.BytesIO(binary_data))

                    y = list(row1)
                    y[3] = base64_string
                    row1 = tuple(y)
                    result = []
                    keys = ('name', 'address', 'phone', 'profilePic')

                    result.append(dict(zip(keys, row1)))
                    json_data = json.dumps(result)
                    return HttpResponse(json_data, content_type="application/json")

        else:
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "select name,address,phone,profilePic, workingHour from worker_table where Name='"+str(name) + "'")
                row1 = cursor_1.fetchone()

                if row1 == None:
                    json_data = {"message": "Wrong"}
                    return HttpResponse(json_data, content_type="application/json")
                else:
                    im = row1[3]
                    # binary_data = base64.b64decode(im)
                    base64_string = im.decode('utf-8')

                    # Cimage = Image.open(io.BytesIO(binary_data))

                    y = list(row1)
                    y[3] = base64_string
                    row1 = tuple(y)

                    result = []
                    keys = ('name', 'address', 'phone',
                            'profilePic', 'workingHour')

                    result.append(dict(zip(keys, row1)))
                    json_data = json.dumps(result)
                    # print(json_data)
                    return HttpResponse(json_data, content_type="application/json")


@csrf_exempt
def updateProfileInfoAddress(request):
    if request.method == 'POST':
        address = request.POST.get("address", False)
        phone = request.POST.get("phone", False)
        with connection.cursor() as cursor_1:
            cursor_1.execute("UPDATE homeowner SET Address='" +
                             str(address) + "' where Phone='"+str(phone) + "'")
            connection.commit()
    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def updateProfileInfoWorkingHour(request):
    if request.method == 'POST':
        workingHour = request.POST.get("workingHour", False)
        phone = request.POST.get("phone", False)
        with connection.cursor() as cursor_1:
            cursor_1.execute("UPDATE worker_table SET workingHour='" +
                             str(workingHour) + "' where Phone='"+str(phone) + "'")
            connection.commit()
    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def deleteProfile(request):
    if request.method == 'POST':
        name = request.POST.get("name", False)
        phone = request.POST.get("phone", False)
        type = request.POST.get("type", False)
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute("DELETE from homeowner where Name='" +
                                 str(name) + "' and Phone='"+str(phone) + "'")
                connection.commit()
        else:
            with connection.cursor() as cursor_1:
                cursor_1.execute("DELETE from worker_table where Name='" +
                                 str(name) + "' and Phone='"+str(phone) + "'")
                connection.commit()
    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def createWorkOwner(request):
    if request.method == 'POST':
        phone = request.POST.get("phone", False)
        workName = request.POST.get("workName", False)
        workPrice = request.POST.get("workPrice", False)
        type = request.POST.get("type", False)
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute("INSERT INTO worktablehomeowner(Phone,workName,price) VALUES ('"+str(
                    phone) + "' ,'"+str(workName) + "','"+str(workPrice) + "' )")
                connection.commit()
    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def getallworkList(request):
    if request.method == 'POST':
        phone = request.POST.get("phone", False)
        type = request.POST.get("type", False)
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "SELECT workName, price FROM worktablehomeowner where Phone='"+str(phone) + "'")
                row1 = cursor_1.fetchall()
            result = []
            keys = ('workName', 'price')
            for row in row1:
                result.append(dict(zip(keys, row)))
            json_data = json.dumps(result)

            return HttpResponse(json_data, content_type="application/json")
    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def removeWorkFromList(request):
    if request.method == 'POST':
        phone = request.POST.get("phone", False)
        type = request.POST.get("type", False)
        workName = request.POST.get("workName", False)
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute("DELETE FROM worktablehomeowner where Phone='" +
                                 str(phone) + "' and workName='"+str(workName) + "' ")
                connection.commit()
    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def writeReview(request):
    if request.method == 'POST':
        workerPhone = request.POST.get("workerPhone", False)
        ownerPhone = request.POST.get("ownerPhone", False)
        review = request.POST.get("review", False)
        type = request.POST.get("type", False)
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute("INSERT INTO workerreview(OwnerPhone,WorkerPhone,Review) VALUES ('"+str(
                    ownerPhone) + "' ,'"+str(workerPhone) + "','"+str(review) + "' )")
                connection.commit()
        else:
            with connection.cursor() as cursor_1:
                cursor_1.execute("INSERT INTO ownerreview(OwnerPhone,WorkerPhone,Review) VALUES ('"+str(
                    workerPhone) + "' ,'"+str(ownerPhone) + "','"+str(review) + "' )")
                connection.commit()
    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def getReview(request):
    if request.method == 'POST':
        workerPhone = request.POST.get("workerPhone", False)
        type = request.POST.get("type", False)
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "SELECT Review FROM workerreview where WorkerPhone='"+str(workerPhone) + "'")
                row1 = cursor_1.fetchall()
            result = []
            keys = ('Review')
            for row in row1:
                result.append(dict(zip(keys, row)))
            json_data = json.dumps(result)
            return HttpResponse(json_data, content_type="application/json")

        else:
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "SELECT Review FROM ownerreview where OwnerPhone='"+str(workerPhone) + "'")
                row1 = cursor_1.fetchall()
            result = []
            keys = ('Review')
            for row in row1:
                result.append(dict(zip(keys, row)))
            json_data = json.dumps(result)
            return HttpResponse(json_data, content_type="application/json")
    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def applyAppoint(request):
    if request.method == 'POST':
        workerPhone = request.POST.get("workerPhone", False)
        ownerPhone = request.POST.get("ownerPhone", False)
        type = request.POST.get("type", False)
        status = "Disable"
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute("INSERT INTO appointtableowner(OwnerPhone,WorkerPhone,requestedby,status) VALUES ('"+str(
                    ownerPhone) + "' ,'"+str(workerPhone) + "','"+str(type) + "','"+str(status) + "' )")
                connection.commit()
        else:
            with connection.cursor() as cursor_1:
                cursor_1.execute("INSERT INTO appointtableowner(OwnerPhone,WorkerPhone,requestedby,status) VALUES ('"+str(
                    ownerPhone) + "' ,'"+str(workerPhone) + "','"+str(type) + "','"+str(status) + "')")
                connection.commit()
    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def getAppointList(request):
    if request.method == 'POST':
        workerPhone = request.POST.get("workerPhone", False)
        type = request.POST.get("type", False)
        status = "Disable"
        mytype = "Worker"
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "select name,address,phone,profilePic from worker_table inner join appointtableowner on worker_table.phone = appointtableowner.WorkerPhone where OwnerPhone='"+str(workerPhone) + "' and status = '"+str(status) + "' and requestedby = '"+str(mytype) + "'")
                row1 = cursor_1.fetchall()
            result = []
            keys = ('name', 'address', 'phone', 'profilePic')
            for row in row1:
                im = row[3]
                base64_string = im.decode('utf-8')
                y = list(row)
                y[3] = base64_string
                row = tuple(y)
                result.append(dict(zip(keys, row)))
            json_data = json.dumps(result)
            # print(json_data)
            return HttpResponse(json_data, content_type="application/json")
        else:
            mytype = "HomeOwner"
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "select name,address,phone,profilePic from homeowner inner join appointtableowner on homeowner.phone = appointtableowner.OwnerPhone where WorkerPhone='"+str(workerPhone) + "' and status = '"+str(status) + "' and requestedby = '"+str(mytype) + "'")
                row1 = cursor_1.fetchall()
            result = []
            keys = ('name', 'address', 'phone', 'profilePic')
            for row in row1:
                im = row[3]
                base64_string = im.decode('utf-8')
                y = list(row)
                y[3] = base64_string
                row = tuple(y)
                result.append(dict(zip(keys, row)))
            json_data = json.dumps(result)
            # print(json_data)
            return HttpResponse(json_data, content_type="application/json")


@csrf_exempt
def acceptAppoint(request):
    if request.method == 'POST':
        workerPhone = request.POST.get("workerPhone", False)
        ownerPhone = request.POST.get("ownerPhone", False)
        type = request.POST.get("type", False)
        mytype = "Worker"
        status = "Enable"
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute("update appointtableowner set status = '"+str(status) + "' where requestedby = '"+str(
                    mytype) + "' and OwnerPhone = '"+str(workerPhone) + "' and WorkerPhone = '"+str(ownerPhone) + "'")
                connection.commit()
        else:
            mytype = "HomeOwner"
            with connection.cursor() as cursor_1:
                cursor_1.execute("update appointtableowner set status = '"+str(status) + "' where requestedby = '"+str(
                    mytype) + "' and WorkerPhone = '"+str(workerPhone) + "' and OwnerPhone = '"+str(ownerPhone) + "'")
                connection.commit()

    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def rejectAppoint(request):
    if request.method == 'POST':
        workerPhone = request.POST.get("workerPhone", False)
        ownerPhone = request.POST.get("ownerPhone", False)
        type = request.POST.get("type", False)
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute("delete from appointtableowner where WorkerPhone = '" + str(workerPhone) + "' and OwnerPhone = '"+str(ownerPhone) + "'")
                connection.commit()
        else:
            with connection.cursor() as cursor_1:
                cursor_1.execute("delete from appointtableowner where OwnerPhone = '" + str(workerPhone) + "' and WorkerPhone = '"+str(ownerPhone) + "'")
                connection.commit()

    return HttpResponse("Hello, world. You're at the polls index.")


@csrf_exempt
def getAppointedWorkers(request):
    if request.method == 'POST':
        userPhone = request.POST.get("userPhone", False)
        type = request.POST.get("type", False)
        status = "Enable"
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute("select name,address,phone,profilePic from worker_table inner join appointtableowner on worker_table.phone = appointtableowner.WorkerPhone where OwnerPhone='"+str(
                    userPhone) + "' and status = '"+str(status) + "'")
                row1 = cursor_1.fetchall()
            result = []
            keys = ('name', 'address', 'phone', 'profilePic')
            for row in row1:
                im = row[3]
                base64_string = im.decode('utf-8')
                y = list(row)
                y[3] = base64_string
                row = tuple(y)
                result.append(dict(zip(keys, row)))
            json_data = json.dumps(result)
            return HttpResponse(json_data, content_type="application/json")
        else:
            with connection.cursor() as cursor_1:
                cursor_1.execute("select name,address,phone,profilePic from homeowner inner join appointtableowner on homeowner.phone = appointtableowner.OwnerPhone where WorkerPhone='"+str(
                    userPhone) + "' and status = '"+str(status) + "'")
                row1 = cursor_1.fetchall()
            result = []
            keys = ('name', 'address', 'phone', 'profilePic')
            for row in row1:
                im = row[3]
                base64_string = im.decode('utf-8')
                y = list(row)
                y[3] = base64_string
                row = tuple(y)
                result.append(dict(zip(keys, row)))
            json_data = json.dumps(result)
            return HttpResponse(json_data, content_type="application/json")


@csrf_exempt
def policecomplain(request):
    if request.method == 'POST':
        type = request.POST.get("type", False)
        phone = request.POST.get("phone", False)
        complain = request.POST.get("complain", False)
        if type == "HomeOwner":
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "INSERT INTO policecompainowner(ownerphone,complain) VALUES ('"+str(phone) + "' , '"+str(complain) + "' )")
                connection.commit()
        else:
            with connection.cursor() as cursor_1:
                cursor_1.execute(
                    "INSERT INTO policecompainworker(workerphone,complain) VALUES ('"+str(phone) + "' , '"+str(complain) + "' )")
                connection.commit()

    return HttpResponse("Hello, world. You're at the polls index.")
