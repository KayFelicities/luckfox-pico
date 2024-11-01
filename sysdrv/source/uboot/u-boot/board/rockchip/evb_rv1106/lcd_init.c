/*
 * Add By Kay, 20241030
 */
/*
 * Copyright (C) 2011 Samsung Electronics
 * Lukasz Majewski <l.majewski@samsung.com>
 *
 * (C) Copyright 2010
 * Stefano Babic, DENX Software Engineering, sbabic@denx.de
 *
 * (C) Copyright 2008-2009 Freescale Semiconductor, Inc.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <asm/gpio.h>
#include <spi.h>

#define LCD_WIDTH   128
#define LCD_HEIGHT  64

#define LCD_CD_CMD  0
#define LCD_CD_DATA 1

#define LED_ON      0
#define LED_OFF     1

static struct spi_slave* SpiDev;
static struct gpio_desc GpioLedRed;
static struct gpio_desc GpioLedGreen;
static struct gpio_desc GpioReset;
static struct gpio_desc GpioCd;

void writeCmd(uint8_t cmd) {
    if (SpiDev == 0) {
        debug("writeCmd SpiDev == 0\n");
        return;
    }
    dm_gpio_set_value(&GpioCd, LCD_CD_CMD);
    spi_xfer(SpiDev, 8, &cmd, NULL, SPI_XFER_BEGIN | SPI_XFER_END);
}

void writeData(uint8_t data) {
    if (SpiDev == 0) {
        debug("writeData SpiDev == 0\n");
        return;
    }
    dm_gpio_set_value(&GpioCd, LCD_CD_DATA);
    spi_xfer(SpiDev, 8, &data, NULL, SPI_XFER_BEGIN | SPI_XFER_END);
}

static int lcdInit(void) {
    /* lcd init */
    writeCmd(0xAE); /*display off*/
    writeCmd(0x02); /*set lower column address*/
    writeCmd(0x10); /*set higher column address*/
    writeCmd(0x40); /*set display start line*/
    writeCmd(0xB0); /*set page address*/
    writeCmd(0x81); /*contract control*/
    writeCmd(0x80); /*128*/
    writeCmd(0xA1); /*set segment remap*/
    writeCmd(0xA6); /*normal / reverse*/
    writeCmd(0xA8); /*multiplex ratio*/
    writeCmd(0x3F); /*duty = 1/64*/
    writeCmd(0xad); /*set charge pump enable*/
    writeCmd(0x8b); /* 0x8B 内供 VCC */
    writeCmd(0x33); /*0X30---0X33 set VPP 9V */
    writeCmd(0xC8); /*Com scan direction*/
    writeCmd(0xD3); /*set display offset*/
    writeCmd(0x00); /* 0x20 */
    writeCmd(0xD5); /*set osc division*/
    writeCmd(0x80);
    writeCmd(0xD9); /*set pre-charge period*/
    writeCmd(0XD2); /*0x22*/
    writeCmd(0xDA); /*set COM pins*/
    writeCmd(0x12);
    writeCmd(0xdb); /*set vcomh*/
    writeCmd(0x40);
    writeCmd(0xAF); /*display ON*/
    return 0;
}

int32_t lcdReset(void) {
    dm_gpio_set_value(&GpioReset, 0);
    udelay(50 * 1000);
    dm_gpio_set_value(&GpioReset, 1);
    udelay(50 * 1000);

    lcdInit();
    udelay(10 * 1000);
    return 0;
}

static void lcdBrush(uint8_t* buf, uint32_t len) {
    if (SpiDev == 0) return;

    for (int page = 0; page < LCD_HEIGHT / 8; page++) {
        // setPageAddress
        writeCmd(0xB0 + (page & 0x0f));

        // setColumnAddress, sh1106 132 bytes per page
        writeCmd((2 & 0x0f) | 0x00);
        writeCmd((2 >> 4) | 0x10);

        for (int col = 0; col < LCD_WIDTH; col++) {
            writeData(buf[page * LCD_WIDTH + col]);
        }
    }
}

#include "lcd_logo.c"
static int sh1106ShowLogo(void) {
    lcdReset();

    // lcdBrush(logoBuf, sizeof(logoBuf));
    lcdBrush(startingBuf, sizeof(startingBuf));

    return 0;
}

int lcd_init(void) {
    printf("uboot oled\n");
    int ret;

    /* spi */
    struct udevice* bus;
    ret = spi_get_bus_and_cs(0, 0, 10 * 1000 * 1000, 0, "spi_generic_drv", "oled_sh1106", &bus, &SpiDev);
    // SpiDev = spi_setup_slave(0, 0, 10 * 1000 * 1000, 0);
    if (!SpiDev) {
        printf("%s: Failed to set up slave\n", __func__);
        return -1;
    }

    ret = spi_claim_bus(SpiDev);
    if (ret) {
        printf("%s: Failed to claim SPI bus: %d\n", __func__, ret);
        goto err_claim_bus;
    }

    /* gpios */
    ofnode node = ofnode_path("/uboot-gpios");
    ret = gpio_request_by_name_nodev(node, "spi-reset", 0, &GpioReset, GPIOD_IS_OUT);
    if (ret < 0) printf("Failed to request spi-reset: %d\n", ret);
    ret = gpio_request_by_name_nodev(node, "spi-cd", 0, &GpioCd, GPIOD_IS_OUT);
    if (ret < 0) printf("Failed to request spi-cd: %d\n", ret);
    ret = gpio_request_by_name_nodev(node, "led-red", 0, &GpioLedRed, GPIOD_IS_OUT);
    if (ret < 0) printf("Failed to request led-red: %d\n", ret);
    ret = gpio_request_by_name_nodev(node, "led-green", 0, &GpioLedGreen, GPIOD_IS_OUT);
    if (ret < 0) printf("Failed to request led-green: %d\n", ret);

    dm_gpio_set_value(&GpioLedRed, LED_OFF);
    dm_gpio_set_value(&GpioLedGreen, LED_OFF);

    sh1106ShowLogo();

    return 0;
err_claim_bus:
    spi_free_slave(SpiDev);
    return -1;
}
