FROM archlinux:20200908

# Pacman and yay wrapper
ENV pacman="sudo pacman -y --noconfirm"
ENV yay="yay -y --noconfirm"

# Create and log as notroot user for makepkg
RUN pacman --noconfirm -Syy base-devel
RUN useradd -m notroot
RUN echo "notroot ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/notroot
USER notroot
WORKDIR /home/notroot

# Install yay
RUN $pacman -S git
RUN git clone 'https://aur.archlinux.org/yay-bin.git'
WORKDIR /home/notroot/yay-bin
RUN ls -la
RUN makepkg --noconfirm -si
WORKDIR /home/notroot/
RUN rm -r yay-bin

# Install packages needed by the CI
RUN $pacman -S meson ninja gcc clang
RUN $yay -S criterion

# Make us root again for Github Action
USER root
