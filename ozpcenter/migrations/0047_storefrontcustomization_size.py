# -*- coding: utf-8 -*-

from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ozpcenter', '0046_auto_20180711_1811'),
    ]

    operations = [
        migrations.AddField(
            model_name='storefrontcustomization',
            name='size',
            field=models.CharField(blank=True, choices=[('LARGE', 'LARGE'), ('SMALL', 'SMALL')], max_length=50, null=True),
        ),
    ]
