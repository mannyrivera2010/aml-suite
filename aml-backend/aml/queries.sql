/*===========
query_name: example1
from amlcenter.models import get_user_excluded_orgs;
get_user_excluded_orgs(Profile.objects.get(user__username='wsmith'))
===========*/
SELECT "amlcenter_agency"."id", "amlcenter_agency"."title", "amlcenter_agency"."icon_id", "amlcenter_agency"."short_name"
FROM "amlcenter_agency"
WHERE NOT ("amlcenter_agency"."id" IN (
	SELECT U0."id" AS Col1
	FROM "amlcenter_agency" U0
	INNER JOIN "stewarded_agency_profile" U1 ON (U0."id" = U1."agency_id")
	WHERE U1."profile_id" = 5));

/*===========
query_name: get_listings
Query to get all listings
===========*/
SELECT
  amlcenter_listing.id,
  amlcenter_listing.title,
  amlcenter_listing.approved_date,
  amlcenter_listing.edited_date,
  amlcenter_listing.description,
  amlcenter_listing.launch_url,
  amlcenter_listing.version_name,
  amlcenter_listing.unique_name,
  amlcenter_listing.what_is_new,
  amlcenter_listing.usage_requirements,
  amlcenter_listing.system_requirements,
  amlcenter_listing.description_short,
  amlcenter_listing.approval_status,
  amlcenter_listing.is_enabled,
  amlcenter_listing.is_featured,
  amlcenter_listing.avg_rate,
  amlcenter_listing.total_rate1,
  amlcenter_listing.total_rate2,
  amlcenter_listing.total_rate3,
  amlcenter_listing.total_rate4,
  amlcenter_listing.total_rate5,
  amlcenter_listing.total_votes,
  amlcenter_listing.total_reviews,
  amlcenter_listing.feedback_score,
  amlcenter_listing.iframe_compatible,
  amlcenter_listing.security_marking,
  amlcenter_listing.is_private,
  amlcenter_listing.current_rejection_id,
  amlcenter_listing.last_activity_id,
  amlcenter_listing.listing_type_id,
  amlcenter_listing.required_listings_id,
  amlcenter_listing.is_deleted,

  /* One to Many */
  amlcenter_listing.listing_type_id,
  amlcenter_listingtype.title listing_type_title,

  /* One to Many Images*/
  amlcenter_listing.agency_id agency_id,
  amlcenter_agency.title agency_title,
  amlcenter_agency.short_name agency_short_name,

  amlcenter_listing.small_icon_id,
  small_icon.security_marking small_icon_security_marking,

  amlcenter_listing.large_icon_id,
  large_icon.security_marking large_icon_security_marking,

  amlcenter_listing.banner_icon_id,
  banner_icon.security_marking banner_icon_security_marking,

  amlcenter_listing.large_banner_icon_id,
  large_banner_icon.security_marking large_banner_icon_security_marking,

  /* Many to Many */
  /* Category */
  category_listing.category_id,
  amlcenter_category.title category_title,
  amlcenter_category.description categorequiredry_description,

  /* Contact */
  contact_listing.contact_id contact_id,
  amlcenter_contact.contact_type_id contact_type_id, /* Check to see if contact_id and contact_type_id is correct*/
  amlcenter_contacttype.name contact_type_name,
  amlcenter_contact.secure_phone contact_secure_phone,
  amlcenter_contact.unsecure_phone contact_unsecure_phone,
  amlcenter_contact.email contact_email,
  amlcenter_contact.name contact_name,
  amlcenter_contact.organization contact_organization,

  /* Tags */
  tag_listing.tag_id,
  amlcenter_tag.name tag_name,

  /* Owners */
  owners.profile_id,
  owner_profile.display_name owner_display_name,
  owner_profile.user_id owner_user_id,
  owner_user.username owner_username,

  /* Intents */
  intent_listing.intent_id,
  amlcenter_intent.action intent_action,

  /* Bookmarks */
  lib_entries.bookmark_count
FROM
  amlcenter_listing
/* One to Many Joins */
JOIN amlcenter_agency ON (amlcenter_listing.agency_id = amlcenter_agency.id)
JOIN amlcenter_listingtype ON (amlcenter_listingtype.id = amlcenter_listing.listing_type_id)
JOIN amlcenter_image small_icon ON (small_icon.id = amlcenter_listing.small_icon_id)
JOIN amlcenter_image large_icon ON (large_icon.id = amlcenter_listing.small_icon_id)
JOIN amlcenter_image banner_icon ON (banner_icon.id = amlcenter_listing.small_icon_id)
JOIN amlcenter_image large_banner_icon ON (large_banner_icon.id = amlcenter_listing.small_icon_id)
/* Many to Many Joins */

/* Categories */
LEFT JOIN category_listing ON (category_listing.listing_id = amlcenter_listing.id)
LEFT JOIN amlcenter_category on (category_listing.category_id = amlcenter_category.id)

/* Contacts */
LEFT JOIN contact_listing ON (contact_listing.listing_id = amlcenter_listing.id)
LEFT JOIN amlcenter_contact on (contact_listing.contact_id = amlcenter_contact.id)
LEFT JOIN amlcenter_contacttype on (amlcenter_contact.contact_type_id = amlcenter_contacttype.id)

/* Tags */
LEFT JOIN tag_listing ON (tag_listing.listing_id = amlcenter_listing.id)
LEFT JOIN amlcenter_tag ON (tag_listing.tag_id = amlcenter_tag.id)

/* Owners */
LEFT JOIN profile_listing owners ON (owners.listing_id = amlcenter_listing.id)
LEFT JOIN amlcenter_profile owner_profile ON (owners.profile_id = owner_profile.id)
LEFT JOIN auth_user owner_user ON (owner_profile.user_id = owner_user.id)

/* Intent */
LEFT JOIN intent_listing ON (intent_listing.listing_id = amlcenter_listing.id)
LEFT JOIN amlcenter_intent ON (intent_listing.intent_id = amlcenter_intent.id)

/* Bookmarks */
LEFT JOIN (SELECT amlcenter_applicationlibraryentry.listing_id, count(amlcenter_applicationlibraryentry.listing_id) bookmark_count
           FROM amlcenter_applicationlibraryentry
           GROUP BY amlcenter_applicationlibraryentry.listing_id) lib_entries ON (lib_entries.listing_id = amlcenter_listing.id)
/*
Get Listings that are enabled, not deleted, and approved
*/
WHERE amlcenter_listing.is_enabled = {} AND
      amlcenter_listing.is_deleted = {} AND
      amlcenter_listing.approval_status = 'APPROVED'
ORDER BY amlcenter_listing.approved_date DESC;

/*===========
query_name: get_roles_orgs
Query to get user roles and orgs
===========*/
SELECT
  amlcenter_profile.id profile_id,
  amlcenter_profile.display_name profile_display_name,
  auth_user.username profile_username,
  auth_group.name profile_group_name,
  CASE auth_group.name
    WHEN 'APPS_MALL_STEWARD' THEN 1
    WHEN 'ORG_STEWARD' THEN 2
    WHEN 'USER' THEN 3
  END role_priority,
  agency.title agency_title,
  steward_agency.title steward_agency

FROM amlcenter_profile
  JOIN auth_user ON (amlcenter_profile.user_id = auth_user.id)
  JOIN auth_user_groups ON (auth_user_groups.user_id = auth_user.id)
  JOIN auth_group ON (auth_user_groups.group_id = auth_group.id)

  LEFT JOIN agency_profile ON (amlcenter_profile.id = agency_profile.profile_id)
  LEFT JOIN amlcenter_agency agency ON (agency_profile.agency_id = agency.id)

  LEFT JOIN stewarded_agency_profile ON (amlcenter_profile.id = stewarded_agency_profile.profile_id)
  LEFT JOIN amlcenter_agency steward_agency ON (stewarded_agency_profile.agency_id = steward_agency.id)

ORDER BY profile_username, role_priority
