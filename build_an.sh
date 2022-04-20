#!/bin/bash

# NDK=/home/ndk/android-ndk-r15c

ADDI_CFLAGS="-fPIE -pie"
ADDI_LDFLAGS="-fPIE -pie"



configure()
{
CPU=$1
PREFIX=$(pwd)/android/$CPU
if [ ! -d "$PREFIX" ] ; then
echo "file not found"
mkdir -p $PREFIX
fi

HOST=""
CROSS_PREFIX=""
SYSROOT=""
ARCH=""
if [ "$CPU" == "armv7-a" ]
then
ARCH="arm"
HOST=arm-linux
SYSROOT=$NDK/platforms/android-21/arch-arm/
CROSS_PREFIX=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
else
ARCH="aarch64"
HOST=aarch64-linux
SYSROOT=$NDK/platforms/android-21/arch-arm64/
CROSS_PREFIX=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-
fi

./configure \
--prefix=$PREFIX \
--enable-encoders \
--enable-decoders \
--enable-avdevice \
--disable-static \
--disable-doc \
--enable-ffplay \
--enable-network \
--disable-doc \
--enable-symver \
--enable-neon \
--enable-shared \
--enable-gpl \
--enable-pic \
--enable-jni \
--enable-pthreads \
--enable-mediacodec \
--enable-encoder=aac \
--enable-encoder=gif \
--enable-encoder=libopenjpeg \
--enable-encoder=libmp3lame \
--enable-encoder=libwavpack \
--enable-encoder=mpeg4 \
--enable-encoder=pcm_s16le \
--enable-encoder=png \
--enable-encoder=srt \
--enable-encoder=subrip \
--enable-encoder=yuv4 \
--enable-encoder=text \
--enable-decoder=aac \
--enable-decoder=aac_latm \
--enable-decoder=aac_at \
--enable-decoder=aac_fixed \
--enable-decoder=eac3 \
--enable-decoder=eac3_at \
--enable-decoder=atrac3 \
--enable-decoder=atrac3al \
--enable-decoder=atrac3p \
--enable-decoder=atrac3pal \
--enable-decoder=ac3 \
--enable-decoder=ac3_at \
--enable-decoder=ac3_fixed \
--enable-decoder=libopenjpeg \
--enable-decoder=mp3 \
--enable-decoder=mpeg4_mediacodec \
--enable-decoder=pcm_s16le \
--enable-decoder=flac \
--enable-decoder=flv \
--enable-decoder=gif \
--enable-decoder=png \
--enable-decoder=srt \
--enable-decoder=xsub \
--enable-decoder=yuv4 \
--enable-decoder=vp8_mediacodec \
--enable-decoder=h264_mediacodec \
--enable-decoder=hevc_mediacodec \
--enable-hwaccel=h264_mediacodec \
--enable-hwaccel=mpeg4_mediacodec \
--enable-ffmpeg \
--enable-bsf=aac_adtstoasc \
--enable-bsf=h264_mp4toannexb \
--enable-bsf=hevc_mp4toannexb \
--enable-bsf=mpeg4_unpack_bframes \
--enable-cross-compile \
--cross-prefix=$CROSS_PREFIX \
--target-os=android \
--arch=$ARCH \
--sysroot=$SYSROOT
}

copy_header()
{
CPU=$1
PREFIX=$(pwd)/android/$CPU
echo $CPU-$PREFIX
mkdir -p $PREFIX/include_all/libavcodec/
mkdir -p $PREFIX/include_all/libavdevice/
mkdir -p $PREFIX/include_all/libavfilter/
mkdir -p $PREFIX/include_all/libavformat/
mkdir -p $PREFIX/include_all/libavutil/
mkdir -p $PREFIX/include_all/libpostproc/
mkdir -p $PREFIX/include_all/libswresample/
mkdir -p $PREFIX/include_all/libswscale/

cp libavcodec/*.h $PREFIX/include_all/libavcodec/
cp libavdevice/*.h $PREFIX/include_all/libavdevice/
cp libavfilter/*.h $PREFIX/include_all/libavfilter/
cp libavformat/*.h $PREFIX/include_all/libavformat/
cp libavutil/*.h $PREFIX/include_all/libavutil/
cp libpostproc/*.h $PREFIX/include_all/libpostproc/
cp libswresample/*.h $PREFIX/include_all/libswresample/
cp libswscale/*.h $PREFIX/include_all/libswscale/
cp config.h $PREFIX/include_all/
}

build()
{
make clean
cpu=$1
echo "build $cpu"

configure $cpu
make -j8
make install
copy_header $cpu
}
build arm64
build armv7-a