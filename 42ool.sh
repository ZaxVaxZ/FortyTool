#!/user/env/bin bash

set -e
echo "Creating directory $HOME/42ool..."
mkdir ~/42ool && cd ~/42ool
git clone https://github.com/ombhd/Cleaner_42.git 42Cleaner || echo "Unexpected issue while fetching cclean tool"
$(cd 42Cleaner && chmod +x ./CleanerInstaller.sh && yes | ./CleanerInstaller.sh) || echo "Unexpected issue while running cclean tool"
bash -c "$(curl -fsSL https://raw.github.com/xicodomingues/francinette/master/bin/install.sh)" || echo "Unexpected issue while fetching francinette tool"
$(git clone https://github.com/zakarm/Valgrind_42_Network.git && cd Valgrind_42_Network  && chmod +x script.sh && ./script.sh) || echo "Unexpected error while installing valgrind"
should_add=$(cat ~/.zshrc | grep "ZAX" | wc -w )
if [[ "$should_add" -eq 0 ]]; then
	echo "Creating a folder for your projects on Desktop. Please enter folder name:"
	read proj_folder
	proj_folder="$HOME/Desktop/$proj_folder"
	echo "
	# Helpful shortcuts brought to you by ZAX
	makemake() {
		echo '
			CC=cc
			CFLAGS=-Wall -Wextra -Werror
			SRCS=main.c
			OBJS=\${SRCS:.c=.o}
			NAME=executable

			all: $(NAME)
			
			$(NAME): $(OBJS)
				$(CC) $(CFLAGS) $(OBJS) -o $(NAME)

			%.o: %.c
				$(CC) $(CFLAGS) -c \$< -o \$@

			clean:
				rm -rf $(OBJS)
			
			fclean: clean
				rm -rf $(NAME)
			
			re: fclean all
			
			.PHONY: all clean fclean re'
		>Makefile && echo "Default Makefile created"
	}
	42() {
		cd $proj_folder
	}
	go() {
		cd "$proj_folder/\$1"
	}
	project() {
		mkdir -p "$proj_folder/\$1" && go "\$1" && makemake
	}
	connect() {
		git config --global init.defaultBranch main;
		go "\$1" && rm -rf .git && git init && git add . && git commit -m "First project commit" && git branch -M main && git remote add origin "\$2" && git push -u origin main
	}
	re() {
		make re && make clean
	}
	push() {
		git add . && git commit -m "\$1" && git push
	}
	" >>~/.zshrc
fi