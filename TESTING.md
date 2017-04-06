1. Who: Yonghao Zhang (SilentSinger)
        Xinyi Zhang (Hathaaaway)
        Tianlun Zhao (BlakeTZ)
        Yidong Gao (YidongGao)
        Zhuangzhuang jiang (jzz0917)

2. Title: launching!!

3. Vision: See how far you could launch the rabbit. A little game that worked properly in one hand. Great 2 minutes game for spare time.

4. Automated Tests:
    https://developer.apple.com/xcode/
    As we are using the Xcode to develop the IOS app, we could perform the automated tests through the compiler directly.
    When running the code for test, we got running successfully along with the output:
    2017-04-06 16:19:41.860831-0600 Angry Duck - 2[659:61309] [DYMTLInitPlatform] platform initialization successful
    2017-04-06 16:19:42.202763-0600 Angry Duck - 2[659:61258] Metal GPU Frame Capture Enabled
    2017-04-06 16:19:42.203374-0600 Angry Duck - 2[659:61258] Metal API Validation Enabled
    2017-04-06 16:19:42.237391-0600 Angry Duck - 2[659:61258] libMobileGestalt MobileGestaltSupport.m:153: pid 659 (Angry Duck - 2) does not have sandbox access for frZQaeyWLUvLjeuEK43hmg and IS NOT appropriately entitled
    2017-04-06 16:19:42.237473-0600 Angry Duck - 2[659:61258] libMobileGestalt MobileGestalt.c:550: no access to InverseDeviceID (see <rdar://problem/11744455>)

5. User Acceptance Tests:
Test 1
Use case name
    Launch the rabbit in random angles.
Description
    Test whether the user could launch the rabbit smoothly without any delay.
Pre-conditions
    Main menu could work properly.
Test steps
    1. Open the game through the testing device
    2. Open the main menu and push start button
    3. Launch the rabbit in random angles
Expected result
    The rabbit could launch properly without any delay. User should also test the counter position that make sure the rabbit could launch in the nagative direction.
Actual result
    Rabbit would be able to launch at any angles. Some delay might occur if the user push the rabbit downwards. In this case, user needed to point the rabbit in order to launch it.
Status (Pass/Fail)
    Pass
Notes
    Need a little bit change about the downwards angle.
Post-conditions
    User is able to launch the rabbit properly. The game could start normally.


Test 2
Use case name
    Testing the interface
Description
    Testing whether the background and other element could move along with the rabbit after launching the it.
Pre-conditions
    The rabbit has been launched successfully.
Test steps
    1. Open the game through the testing device
    2. Open the main menu and push start button
    3. Launch the rabbit in random angles
    4. Observe the background and ground during the process of launching
Expected result
    The background and other elements could move along with the rabbit. Like a camera focusing on the rabbit.
Actual result
    The background showed some grey black when the rabbit dropped too far away.
Status (Pass/Fail)
    Fail
Notes
    Could not be able to launch the rabbit high enough so the height of the background was still under testing.
Post-conditions
    Fail to display the background along with the rabbit when the rabbit dropped too far away. Need improve this part. Also need to make sure that the rabbit could be launched high enough too show the vertical aspect of the background.


Test 3
Use case name
    Verify the rabbit could restart its position after dropping
Description
    After launch the rabbit and by the time the rabbit dropping on the ground, the game interface should be reset and the rabbit was placeed on its original location for the user to play it again.
Pre-conditions
    The rabbit has been launched successfully.
Test steps
    1. Open the game through the testing device
    2. Open the main menu and push start button
    3. Launch the rabbit in random angles
    4. The rabbit formed a parabola and dropped on the ground
    5. Interface reset and user could start again
Expected result
    Interface reseted successfully.
Actual result
    The interface reseted properly.
Status (Pass/Fail)
    Pass -- but need adding more details in this part
Notes
    Need display the distance the rabbit been reached. And leave some time, like 3-4 second for user to see the distance.
Post-conditions
    Game could be restarted successfully after finishing a whole process.
