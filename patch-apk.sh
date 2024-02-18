#!/bin/bash
# alias to display [Done] in green

md5version=''
printbin=''
p2f="$(pwd)"
if [[ "$OSTYPE" == "darwin"* ]]; then
    md5version="md5 -r"
	printbin="echo -e"
	if [ -d ~/Library/Android/sdk/build-tools/]; then
		cd "~/Library/Android/sdk/build-tools"
		aapt_path=$(ls -v | tail -n1)
	else:
		echo "aapt not installed"
		exit 2
	fi
else
    md5version="md5sum"
	printbin="printf"
fi

display_done() {
	$printbin "\e[1;32m[Done]\e[0m\n"
}

# alias to display text in cyan
display_cyan() {
	$printbin "\e[1;36m%s\e[0m" "$1"
}

# alias to display text in light red
display_light_red() {
	$printbin "\e[1;91m%s\e[0m" "$1"
}

# start of script
clear
$printbin "\e[1;91m==========================\n"
$printbin " NetherSX2 Patcher v1.8\n"
$printbin "==========================\e[0m\n"

# Check if the NetherSX2 APK exists and if it's named
#Added logic to download the file, but unsure if that's wanted/needed for this script.
# if [ ! -f "15210-v1.5-4248-noads.apk" ]; then
# 	echo -ne "\e[96mDownloading \e[0m\e[94mAetherSX2...\e[0m"
#     curl -s -o "$input_path/15210-v1.5-4248.apk" "https://github.com/Trixarian/NetherSX2-patch/releases/download/0.0/15210-v1.5-4248.apk"
#     echo -e "\e[92m[Done]\e[0m"
# 	if  [ "$($md5version "15210-v1.5-4248-noads.apk" | awk '{print $1}')" = "c98b0e4152d3b02fbfb9f62581abada5" ]; then
# 	$printbin "\e[0;31mError: No APK found or wrong one provided!\n"
# 	$printbin "Please provide a copy of NetherSX2 named 15210-v1.5-4248-noads.apk!\e[0m\n"
# 	exit 1
# 	fi
# fi
cd "$p2f"
if [ ! -f "15210-v1.5-4248.apk" ] || [ "$($md5version "15210-v1.5-4248.apk" | awk '{print $1}')" = "c98b0e4152d3b02fbfb9f62581abada5" ]; then
	printf "\e[0;31mError: No APK found or wrong one provided!\n"
	printf "Please provide a copy of NetherSX2 named 15210-v1.5-4248.apk!\e[0m\n"
	exit 1
fi


if command -v "$aapt_path/aapt" >/dev/null 2>&1; then
	# Ad Services Cleanup
	display_cyan "Removing the "
	display_light_red "Ad Services leftovers...         "
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk user-messaging-platform.properties			> /dev/null 2>&1
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-tasks.properties				> /dev/null 2>&1
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-measurement-sdk-api.properties		> /dev/null 2>&1
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-measurement-base.properties		> /dev/null 2>&1
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-basement.properties			> /dev/null 2>&1
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-base.properties				> /dev/null 2>&1
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-appset.properties			> /dev/null 2>&1
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-ads.properties				> /dev/null 2>&1
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-ads-lite.properties			> /dev/null 2>&1
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-ads-identifier.properties		> /dev/null 2>&1
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-ads-base.properties			> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	else
		$printbin "\e[1;32m[Already removed]\e[0m\n"
	fi

	# Updates the FAQ to show that we're using the latest version of NetherSX2
	display_cyan "Updating the "
	display_light_red "FAQ...                           "
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/faq.html
	$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/faq.html					> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	# Updates to Latest GameDB with features removed that are not supported by the libemucore.so from March 13th
	display_cyan "Updating the "
	display_light_red "GameDB...                        "
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/GameIndex.yaml
	$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/GameIndex.yaml					> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	# Updates the Game Controller Database
	display_cyan "Updating the "
	display_light_red "Controller Database...           "
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/game_controller_db.txt
	$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/game_controller_db.txt				> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	# Updates the Widescreen Patches
	display_cyan "Updating the "
	display_light_red "Widescreen Patches...            "
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/cheats_ws.zip
	$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/cheats_ws.zip					> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	# Updates the No-Interlacing Patches
	display_cyan "Updating the "
	display_light_red "No-Interlacing Patches...        "
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/cheats_ni.zip
	$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/cheats_ni.zip					> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	# Fixes License Compliancy Issue
	display_cyan "Fixing the "
	display_light_red "License Compliancy Issue...        "
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/3rdparty.html
	$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/3rdparty.html					> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	# Adds the placeholder file that makes RetroAchievements Notifications work
	display_cyan "Fixing the "
	display_light_red "RetroAchievements Notifications... "
	$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/placeholder.png					> /dev/null 2>&1
	$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/placeholder.png					> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi
else
	chmod +x lib/$aapt_path/aapt
	display_cyan "Removing the "
	display_light_red "Ad Services leftovers...         "
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk user-messaging-platform.properties			> /dev/null 2>&1
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-tasks.properties			> /dev/null 2>&1
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-measurement-sdk-api.properties	> /dev/null 2>&1
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-measurement-base.properties		> /dev/null 2>&1
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-basement.properties			> /dev/null 2>&1
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-base.properties			> /dev/null 2>&1
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-appset.properties			> /dev/null 2>&1
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-ads.properties			> /dev/null 2>&1
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-ads-lite.properties			> /dev/null 2>&1
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-ads-identifier.properties		> /dev/null 2>&1
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk play-services-ads-base.properties			> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	else
		$printbin "\e[1;32m[Already removed]\e[0m\n"
	fi

	display_cyan "Updating the "
	display_light_red "FAQ...                           "
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/faq.html
	lib/$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/faq.html					> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	display_cyan "Updating the "
	display_light_red "GameDB...                        "
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/GameIndex.yaml
	lib/$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/GameIndex.yaml				> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	display_cyan "Updating the "
	display_light_red "Controller Database...           "
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/game_controller_db.txt
	lib/$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/game_controller_db.txt			> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	display_cyan "Updating the "
	display_light_red "Widescreen Patches...            "
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/cheats_ws.zip
	lib/$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/cheats_ws.zip				> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	display_cyan "Updating the "
	display_light_red "No-Interlacing Patches...        "
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/cheats_ni.zip
	lib/$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/cheats_ni.zip				> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	display_cyan "Fixing the "
	display_light_red "License Compliancy Issue...        "
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/3rdparty.html
	lib/$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/3rdparty.html				> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi

	display_cyan "Fixing the "
	display_light_red "RetroAchievements Notifications... "
	lib/$aapt_path/aapt r 15210-v1.5-4248-noads.apk assets/placeholder.png				> /dev/null 2>&1
	lib/$aapt_path/aapt a 15210-v1.5-4248-noads.apk assets/placeholder.png				> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		display_done
	fi
fi

# Resigns the APK before exiting
if command -v "apksigner" >/dev/null 2>&1; then
	display_cyan "Resigning the "
	display_light_red "NetherSX2 APK...                "
	apksigner sign --ks lib/android.jks --ks-pass pass:android_sign --key-pass pass:android_sign_alias 15210-v1.5-4248-noads.apk
	if [ $? -eq 0 ]; then
		display_done
	fi
else
	display_cyan "Resigning the "
	display_light_red "NetherSX2 APK...                "
	java -jar lib/apksigner.jar sign --ks lib/android.jks --ks-pass pass:android_sign --key-pass pass:android_sign_alias 15210-v1.5-4248-noads.apk
	if [ $? -eq 0 ]; then
		display_done
	fi
fi
# Alternate Key:
# if command -v "apksigner" >/dev/null 2>&1; then
# 	display_cyan "Resigning the "
# 	display_light_red "NetherSX2 APK...                "
# 	apksigner sign --ks lib/public.jks --ks-pass pass:public 15210-v1.5-4248-noads.apk
# 	if [ $? -eq 0 ]; then
# 		display_done
# 	fi
# else
# 	display_cyan "Resigning the "
# 	display_light_red "NetherSX2 APK...                "
# 	java -jar lib/apksigner.jar sign --ks lib/public.jks --ks-pass pass:public 15210-v1.5-4248-noads.apk
# 	if [ $? -eq 0 ]; then
# 		display_done
# 	fi
# fi
