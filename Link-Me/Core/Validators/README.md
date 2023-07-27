//  Created by Al-attar on 18/12/2021.
//  Copyright © 2021 POMac. All rights reserved.
# 💎  Validators 

🍿 To use an already created Validator 🍿 CHECK THE USAGE EXAMPLE 🔼

🍿 To implement  a new type of validators  🍿 DO THE FOLLOWING ↙️
        
        🚀 Create a struct with the name of your validator
        🚀 Implement the Validable Protocol 
            🧨 The validable protocol contains 2 functions:
                    🔥 validate() which throws a validation Error (check the error class)
                    🔥 isValid() which returns  -> (isVaild:Bool, Message:String ) Implemented by deafult using the validate function✅
        🚀  Add your type in the enum called ValidatorType
        🚀 Refer to the already created types for help
        🚀 AND VOILAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

