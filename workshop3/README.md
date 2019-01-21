# Lab 5

In this lab, you will be walked through how to configure a
virtual box for anonymous daily scraping.

# Things to Know

## Virtualbox and Vagrant

Virtualbox is a free and open source project that is currently maintained
by Oracle. It allows you to spin up an entirely new machine inside the
machine that you are currently using. For example, on my Windows, I regularly
create Linux machines inside this machine.

Vagrant is software that is maintained by Hashicorp and makes using
Virtualbox relatively painless.

To complete this lab, you will need to download both of these:

[https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

[https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

By far the largest advantage of virtual boxes is portability. The ability
to completely replicate an environment down to the machine level on a whim
allows teams to work together extremely effectively.


## Tor

Tor is a browser that is completely focused on anonymity. It uses volunteer
relays around the world to make your resource requests untraceable. Check
out its website to find out more:
[https://www.torproject.org/about/overview.html.en](https://www.torproject.org/about/overview.html.en)


# The Lab

## Getting started

This lab will go over some more advanced scraping tools,
such as virtual boxes and Tor.

First, read the Things to Know section and familiarize yourself
with the tools. 

If you haven't already cloned the Labs repo, do that now. Once
complete, navigate to the directory of this file in your terminal.

Here are the files you should see:

1. `Vagrantfile`

    This file describes the configuration of the desired machine to
    vagrant. Read the code and comments within to get a better idea of
    what's going on.

2. `requirements.txt`

    This file contains python modules that will allow you to use Tor. 
    You will run this file once the machine is up. 

3. `get_ip.py`

    This is a script that we will run once the machine is created

4. `provision/provision.sh`

    This is a bash script that we write that Vagrant will run. It's purpose
    is to equip the machine with everything we need. So we will use `Vagrantfile`
    to create a new machine, and then `provision.sh` to equip the machine
    with all the cool tools we want to use. Read through this.


## Building the machine

Once you've inspected these files, follow these instructions:

1. In this directory, run this command. This will take awhile. First, it
will spawn the machine, then it will run all of the provisioning. If errors
occur, run it again.
```
vagrant up
```

2. Once its finished, you want to log into the machine. Use this:
```
vagrant ssh
```

3. Now you are in the machine. Navigate to the primary directory with:
```
cd /vagrant
```

**Note** You are now in a Linux terminal, even if your host machine is Windows.

4. Now we want to create our Python environment. Run this command:
```
sudo virtualenv --always-copy venv
```

5. There is now a virtual environment in `/vagrant`. Activate it:
```
source venv/bin/activate
```

6. Now install the Python packages. The `-r` flag means recursively,
so it will install everything in the file:
```
pip install -r requirements.txt
```

7. Next, go to your browser on your regular machine and visit
[http://httpbin.org/ip](http://httpbin.org/ip). Take note of your IP.

8. Go to [https://www.iplocation.net/](https://www.iplocation.net/) and
copy and paste your IP in. It should show you your approximate location.
Everytime you send a web request, the receiver gets to know a certain amount
of information about you, location included. That's why we use Tor.

9. Turn your attention pack to your virtual box terminal. Run the
`get_ip.py` file:
```
python get_ip.py
```

10. Copy and paste the printed IP address into
[https://www.iplocation.net/](https://www.iplocation.net/)
like you did with your own. It should show you a random location
(mine is South Africa). If this is the case, you just routed a script through
Tor!!


## Use the new machine

Now let's put this infrastructure to use. Take `Lab3` and `Lab4` and move
them into the machine. That just means putting them somewhere in or below
this directory.

Re-outfit the scripts so that they use the Tor session code found in
`get_ip.py`.  Now run them anonymously through Tor!


## Configure the machine to run scripts daily

Make sure you are in logged into your virtual box with your terminal.

Run

```
man crontab
```

to read the documentation on `crontab`. Press `q` to exit.

`crontab` is how we will ask the machine to run scripts periodically. We
just need to edit the configuration.

Run

```
sudo crontab -e
```

and select `nano` in the editor list. `nano` is just a basic terminal text
editor.

The format of a `crontab` line is as follows:

    'Minute' 'Hour' 'Day of Month' 'Month' 'Day of Week' Command

and asteriks match all times.  For example, to run every day at 6:30pm, we
need the line
```
30 18 * * * <command>
```    

Note that the virtual box is probably operating on UTC, so type
```
date
```

into the terminal to find out what time the machine is running relative to
you.

So if I want to run my `get_ip.py` script every day at 2:25pm, I will add the
following line:

```
25 2 * * * source /vagrant/venv/bin/python /vagrant/get_ip.py
```

Knowing this, configure your scripts to run at some time everyday.

Congratulations! You can scrape data very effectively.


When you are finished with the vagrant you can run:
```
vagrant suspend
```

to put it to sleep.  Run:
```
vagrant destroy
```

if you want to completely shut it down. You will have to completely
reconfigure it next time you `vagrant up`.

