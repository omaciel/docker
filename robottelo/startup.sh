#!/bin/sh

# Checkout Robottelo
git clone -q https://github.com/JacobCallahan/robottelo.git

# Update dependencies, if needed
cd /root/robottelo

pip install -q --upgrade -r requirements.txt
pip install -q --upgrade -r requirements-optional.txt

# Copy the properties file
if [ -e /root/robottelo.properties ]; then
    echo "Copying mounted properties file."
    cp /root/robottelo.properties robottelo.properties
else
	echo "Couldn't find existing properties file. Copying example."
	cp robottelo.properties.sample robottelo.properties
	sed -i "s/^project.*/project=satellite6/" robottelo.properties
	sed -i "s/^# [robottelo].*/[robottelo]/" robottelo.properties
	sed -i "s/^# webdriver.*/webdriver=phantomjs/" robottelo.properties
fi

# Tweak it
if [ ! -z "$SERVER_URL" ]; then
    sed -i "s/^hostname.*/hostname=${SERVER_URL}/" robottelo.properties
fi
if [ ! -z "$SSH_KEY" ]; then
    sed -i "s/^ssh_key.*/ssh_key=${SSH_KEY}/" robottelo.properties
fi
if [ -z "$UPSTREAM" ]; then
    UPSTREAM="false"
fi
sed -i 's/^upstream.*/upstream=${UPSTREAM}/' robottelo.properties

# run the test(s) or the make target
if [ ! -z "$TESTS" ]; then
	py.test -v "$TESTS"
elif [ ! -z "$MAKE" ]; then
	make "$MAKE"
else
	echo "No tests specified! Please refer to documentation."
fi
