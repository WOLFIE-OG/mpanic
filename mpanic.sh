#!/bin/bash

DEF_COLOR='\033[0;39m'
GRAY='\033[0;90m'
RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
BLUE='\033[0;94m'
MAGENTA='\033[0;95m'
CYAN='\033[0;96m'
WHITE='\033[0;97m'
MAIN_COLOR='\033[0;96m'


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  TESTS FUNCTIONS


# >>>> TESTS ECHO

function echo_simple_test()
{
	ARGV=$(echo "$@")
	FTEST=$(echo "$ARGV" | cut -c 5-50)
	PRINT=$(echo "$ARGV" | cut -c 1-4)
	echo -n " "
	printf ${BLUE};
	echo -n " "$PRINT
	printf ${DEF_COLOR};
	echo "$FTEST" > .tmp/exec_read.txt
	< .tmp/exec_read.txt ./minishell &> .tmp/exec_outp.txt
	ES_1=$?
	< .tmp/exec_read.txt bash &> .tmp/bash_outp.txt
	ES_2=$?
	TEST1=$(cat -e .tmp/exec_outp.txt | sed -e "1d" | sed -e "$ d")
	TEST2=$(cat -e .tmp/bash_outp.txt)
	if [ "$TEST1" == "$TEST2" ] && [ "$ES_1" == "$ES_2" ]; then
		printf ${GREEN}"OK";
	else
		TMP=$(echo "$PRINT" | cut -c 1-2)
		echo "------------------------- test [$TMP]" >> traces/echo_trace.txt
		echo "expected: (exit code: $ES_2)" >> traces/echo_trace.txt
		echo "->$TEST2<-" >> traces/echo_trace.txt
		echo "" >> traces/echo_trace.txt
		echo "found: (exit code: $ES_1)" >> traces/echo_trace.txt
		echo "->$TEST1<-" >> traces/echo_trace.txt
		echo "" >> traces/echo_trace.txt
		echo "-------------------------" >> traces/echo_trace.txt
		echo >> traces/echo_trace.txt
		printf ${RED}"KO";
	fi
	printf ${BLUE};
	echo -n "]"
	printf ${DEF_COLOR};
	rm -rf .tmp/exec_outp.txt .tmp/bash_outp.txt
	sleep 0.05
}

function echo_flag_test()
{
	ARGV=$(echo "$@")
	FTEST=$(echo "$ARGV" | cut -c 5-50)
	PRINT=$(echo "$ARGV" | cut -c 1-4)
	echo -n " "
	printf ${BLUE};
	echo -n " "$PRINT
	printf ${DEF_COLOR};
	echo "$FTEST" > .tmp/exec_read.txt
	< .tmp/exec_read.txt ./minishell &> .tmp/exec_outp.txt
	ES_1=$?
	< .tmp/exec_read.txt bash &> .tmp/bash_outp.txt
	ES_2=$?
	str=$(cat .tmp/bash_outp.txt)
	size=${#str}
	TEST2=$(cat -e .tmp/bash_outp.txt)
	# export LC_ALL=C &> /dev/null
	if [ "$size" == "0" ];
	then
		if [ "$(cat -e .tmp/exec_outp.txt | sed -e "1d" | cut -c 1-3)" == "$(cat -e .tmp/exec_outp.txt | sed -e "$ d" | cut -c 1-3)" ];
		then
			printf ${GREEN}"OK";
		fi
	else
		TEST1=$(cat -e .tmp/exec_outp.txt | sed -e "1d" | cut -c 1-$size)
		if [ "$TEST1" == "$TEST2" ] && [ "$ES_1" == "$ES_2" ]; then
			printf ${GREEN}"OK";
		else
			TMP=$(echo "$PRINT" | cut -c 1-2)
			echo "------------------------- test [$TMP]" >> traces/echo_trace.txt
			echo "expected: (exit code: $ES_2)" >> traces/echo_trace.txt
			echo "->$TEST2<-" >> traces/echo_trace.txt
			echo "" >> traces/echo_trace.txt
			echo "found: (exit code: $ES_1)" >> traces/echo_trace.txt
			echo "->$TEST1<-" >> traces/echo_trace.txt
			echo "" >> traces/echo_trace.txt
			echo "-------------------------" >> traces/echo_trace.txt
			echo >> traces/echo_trace.txt
			printf ${RED}"KO";
		fi
	fi
	printf ${BLUE};
	echo -n "]"
	printf ${DEF_COLOR};
	sleep 0.05
}

# >>>>


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


printf ${MAIN_COLOR}"\t\t\t   -----------------------"${DEF_COLOR};
printf ${MAIN_COLOR}"\n\t\t\t  | 👹 MINISHELL PANIC 👹 |\n"${DEF_COLOR};
printf ${MAIN_COLOR}"\t\t\t   -----------------------\n\n"${DEF_COLOR};


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  COMPILATION

MKFF=$(make -C ../ 2> .errors/error.txt)
MK_1=$?
MKFF=$(cat .errors/error.txt | cut -c 1-46)
if [ "$MK_1" != "0" ]; then
	if [ "$MKFF" == "make: *** No targets specified and no makefile" ]; then
		printf ${RED}
		echo "Makefile not found!"
		printf ${DEF_COLOR}
		echo "Remember to clone it and run as follows:"
		echo "  1. cd minishell_project_folder"
		echo "  2. git clone git@github.com:ChewyToast/minishell_panic.git"
		echo "  3. cd minishell_panic"
		echo "  4. bash mpanic.sh"
		echo ""
		printf ${DEF_COLOR}
		rm -rf .errors/error.txt
		exit
	else
		printf ${RED}
		echo "Compilation error"
		printf ${DEF_COLOR}
		echo "-------------"
		echo "$MKFF"
		echo "-------------"
		rm -rf .errors/error.txt
		exit
	fi
else
	cp ../minishell .
	chmod 755 minishell
	mkdir traces &> /dev/null
	mkdir .tmp &> /dev/null
fi

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  TEST CALLS

printf ${BLUE}"\n|===============================[ ECHO TESTS ]================================|\n\n  "${DEF_COLOR}
rm -rf traces/echo_trace.txt &> /dev/null
echo "" > traces/echo_trace.txt
echo "**************************************************************" >> traces/echo_trace.txt
echo "*                          CARE!                             *" >> traces/echo_trace.txt
echo "*                                                            * " >> traces/echo_trace.txt
echo "* This test doesnt work if ur readline prompt have newlines  *" >> traces/echo_trace.txt
echo "*                                                            *" >> traces/echo_trace.txt
echo "**************************************************************" >> traces/echo_trace.txt
echo "" >> traces/echo_trace.txt
echo_simple_test ' 1.[echo ""     '
echo_simple_test ' 2.[echo'
echo_simple_test ' 3.[echO ""    '
echo_simple_test ' 4.[    echo'
echo_simple_test ' 5.[    echo       " hi"'
echo_simple_test ' 6.["echo" ""   '
echo_simple_test ' 7.[echo hi   '
echo_simple_test ' 8.[EcHo hi   '
printf "\n\n  "
echo_simple_test ' 9.[echo """ ""hi" " """'
echo_simple_test '10.[echo "'""'"'
echo_simple_test '11.[echo \"hi\"'
echo_simple_test '12.[echo $HOME'
echo_simple_test '13.[echo $PATH'
echo_simple_test '14.[echo $NONEXIST'
echo_simple_test '15.["      echo"'
echo_simple_test '16.[\ echo "   " $'
printf "\n\n  "
echo_simple_test '17.[echo hi~'
echo_simple_test '18.[echo ~'
echo_simple_test '19.[echo ~false'
echo_simple_test '20.[echo \~'
echo_simple_test '21.[echo "~"ups'
echo_flag_test '22.[echo -n'
echo_flag_test '23.[echo -n hi'
echo_flag_test '24.[echo -nn'
printf "\n\n  "
echo_flag_test '25.[echo -nn hi'
echo_flag_test '26.[echo --n'
echo_flag_test '27.[echo --n hi'
echo_flag_test '28.[echo -n -n'
echo_flag_test '29.[echo -n -n hi'
echo_flag_test '30.[echo -nn -nn'
echo_flag_test '31.[echo -nn -nn hi'
echo_flag_test '32.[echo -n -n -n -n'
printf "\n\n  "
echo_flag_test '33.[echo -n -n -n -n hi'
echo_flag_test '34.[echo -n -n -n \-n hi'
echo_flag_test '35.[echo -nn hi --n'
echo_flag_test '36.[echo \-nn hi --n'
echo_flag_test '37.[echo -nn hi --n'
echo_flag_test '38.[echo -nn hi -n'
echo_flag_test '39.[echo -------------nnnnnnnnnn hi'
printf ${BLUE}"\n\n|===============================================================================|\n\n"
printf ${CYAN}"    To see the failure traces, check in traces/<test_traces>\n\n"
printf "    Any issue send via slack bmoll-pe\n\n"${DEF_COLOR}

# PID=$(ps | grep minishell | grep -v "minishell_panic" | awk '{print $1}')
# printf ${DARK_YELLOW}"\n\t ****      **** /** /****     ** /**   ******** /**      ** /******** /**       /**\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t /**/**   **/** /** /**/**   /** /**  **//////  /**     /** /**/////  /**       /**\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t /**//** ** /** /** /**//**  /** /** /**        /**     /** /**       /**       /**\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t /** //***  /** /** /** //** /** /** /********* /********** /*******  /**       /**\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t /**  //*   /** /** /**  //**/** /** ////////** /**//////** /**////   /**       /**\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t /**   /    /** /** /**   //**** /**        /** /**     /** /**       /**       /**\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t /**        /** /** /**    //*** /**  ********  /**     /** /******** /******** /********\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t //         //  //  //      ///  //  ////////   //      //  ////////  ////////  ////////\n\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t\t\t    *******     **     /****     ** /**    ******\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t\t\t   /**////**   ****    /**/**   /** /**   **////**\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t\t\t   /**   /**  **//**   /**//**  /** /**  **    //\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t\t\t   /*******  **  //**  /** //** /** /** /**\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t\t\t   /**////  ********** /**  //**/** /** /**\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t\t\t   /**     /**//////** /**   //**** /** //**    **\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t\t\t   /**     /**     /** /**    //*** /**  //******\n"${DEF_COLOR};
# printf ${DARK_YELLOW}"\t\t\t   //      //      //  //      ///  //    //////\n\n"${DEF_COLOR};
