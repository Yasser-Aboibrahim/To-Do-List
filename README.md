# To-Do-List
An application to track of daily obligations with date and time using google firebase database to store the
user data and the list of tasks.
It is about 4 Views.

# 1- SignUp View
It contains user name, user email and password.<br/>
 When	the	user	clicks on	Sign	Up	button<br/>
		 - In	case	he/	she	entered invalid	data	he/she	should	see	an<br/>
							alert	tell	him/her	what	is	wrong.<br/>
     - In	case	he/	she	entered valid	data	you	must	save	his/her<br/>
							credentials	to	a	Firebase Database and	if	the	process<br/>
							succeeded he/she	should	go	to	main	screen. Otherwise<br/>
							an	alert	must be shown	with	the	error.<br/>

<br><br>
<img src = "TodoAppPics/SignUp2.png" width = 200 hight = 300> 

# 2- SignUp View
It contains user email and password.<br/>
Check the Regx and the user had signed up before or not.<br/>
<br><br>
<img src = "TodoAppPics/SignIn.png" width = 200 hight = 300> 
<br><br>
<img src = "TodoAppPics/SignUp1.png" width = 200 hight = 300> 

# 3-User List View
It contains:<br/>
1- Backarrow: to get back to signin view to log in with different user.<br/>
2- Plus : to add note (Contetct with it's date and time)
<br><br>
<img src = "TodoAppPics/Main1.png" width = 200 hight = 300>

# 4-PopUP View (note Details)
It contains:<br/>
1- Date and time textfield by user dateAndTime Picker.<br/>
2- content textfield to add whatever the user wants to add.
<br><br>
<img src = "TodoAppPics/Popup1.png" width = 200 hight = 300> 
<br><br>
<img src = "TodoAppPics/Popup2.png" width = 200 hight = 300> 
<br><br>
<img src = "TodoAppPics/Popup3.png" width = 200 hight = 300> 

After adding the note and press save the user list view will show then the note will be added to the view and stored in the firebase database.
<br><br>
<img src = "TodoAppPics/Main2.png" width = 200 hight = 300> 

In case the user wants to delete any note there is a delete icon for each added note to delete it.
<br><br>
<img src = "TodoAppPics/TodoDeletionAlert.png" width = 200 hight = 300> 
