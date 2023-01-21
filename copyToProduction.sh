#!/usr/bin/expect

set productionUser "user1"
set productionPassword "555"
set productionAddress "10.10.0.1"

# find out mannually what is the last line and the last words
# 10.10.0.2 is address of vm with runner (where this script is executed)
set lastWordsFromPreviousOutput "from 10.10.0.2"    

# sometimes ubuntu suggests to upgrade after the connection is established
set lastWordsFromPreviousOutput2 "Run 'do-release-upgrade' to upgrade to it."

# copying s21_cat
spawn scp src/cat/s21_cat $productionUser@$productionAddress:s21_cat

set timeout 10

expect {
    timeout {
        puts "Connection timed out"
        puts "s21_cat was not copied"
        exit 1
    }

    # when connecting for the very first time
    "yes/no" {                              
        send "yes\r"
        exp_continue
    }

    # sending password to establish connection
    "assword:" {                                
        puts "sending password"
        send "$productionPassword\r"
        exp_continue
        exit 0
    }

    "lost connection" {
        puts "Something whent wrong. Perhaps there are issues with the production server"
        exit 1
    }
}


spawn scp src/grep/s21_grep $productionUser@$productionAddress:s21_grep

set timeout 10

expect {
    timeout {
        puts "Connection timed out"
        puts "s21_grep was not copied"
        exit 1
    }

    # when connecting for the very first time
    "yes/no" {                              
        send "yes\r"
        exp_continue
    }

    # sending password to establish connection
    "assword:" {                                
        puts "sending password"
        send "$productionPassword\r"
        exp_continue
        exit 0
    }

    "lost connection" {
        puts "Something whent wrong. Perhaps there are issues with the production server"
        exit 1
    }
}

# moving both s21_cat and s21_grep
spawn ssh -l $productionUser $productionAddress

set timeout 20
expect {
    timeout {
        puts "Connection timed out"
        puts "s21_cat and s21_grep were copied but not moved to the final destination"
        exit 1
    }

    # when connecting for the very first time
    "yes/no" {                              
        send "yes\r"
        exp_continue
    }

    # sending password to establish connection
    "assword:" {                                
        puts "sending password"
        send "$productionPassword\r"
        exp_continue
        exit 0
    }

    # sending password to execute sudo command on remote machine
    "assword for $productionUser:" {        
    puts "sending password for sudo"
    send "$productionPassword\r"

        expect {
            "$ " {
                puts "success"
                # good exit. We have input password after command had reqiured it and have made sure this command \to finish
                exit 0                      
            }                         
            "permission denied" {
                puts "permission denied. Perhaps sudo password is wrong"
                exit 1
            }
        }
    }

    # after the connection is established commands are executed on remote machine
    "$lastWordsFromPreviousOutput" {                
        puts "Moving s21_cat and s21_grep to their final destination"
        send "sudo bash -c 'mv s21_cat /usr/local/bin/' && sudo bash -c 'mv s21_grep /usr/local/bin/'\r"

        exp_continue
    }

    # after the connection is established commands are executed on remote machine
    "$lastWordsFromPreviousOutput2" {                
        puts "Moving s21_cat and s21_grep to their final destination"
        send "sudo bash -c 'mv s21_cat /usr/local/bin/' && sudo bash -c 'mv s21_grep /usr/local/bin/'\r"

        exp_continue
    }
}