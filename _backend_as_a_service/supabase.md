---
title: Supabase Setup
description: >-
    The Supabase setup for a simple chat app
layout: default
---

We are going to create a chat app using Supabase as a backend.

## Create account

![Create an organization with free plan](../supabase_create_organization.png)
![Create a project in nearby region](../supabase_create_project.png)

## Authentication

![Authentication settings](../supabase_authentication_settings.png)

## Tables

### Groups table

![groups table](../supabase_groups_table.png)

### Members table

![members table](../supabase_members_table.png)
![members.group_id key](../supabase_members_group_id_key.png)
![members.group_id options](../supabase_members_group_id_options.png)
![members.user_id options](../supabase_members_user_id_options.png)
![members.user_id key](../supabase_members_user_id_key.png)

### Messages table

![messages table](../supabase_messages_table.png)
![messages.group_id key](../supabase_messages_group_key.png)
![messages.sender_id key](../supabase_messages_sender_key.png)