PROJECT = katja_vmstats
PROJECT_VERSION = 0.4

DEPS = noesis katja
dep_noesis = git https://github.com/nifoc/noesis development
dep_katja = git https://github.com/nifoc/katja development

TEST_DEPS = nifoc_ct_helper
dep_nifoc_ct_helper = git https://github.com/nifoc/nifoc_ct_helper master

ERLC_OPTS ?= -Werror +debug_info +warn_bif_clash +warn_deprecated_function +warn_deprecated_type \
				+warn_export_all +warn_export_vars +warn_shadow_vars +warn_obsolete_guard +warn_unused_import \
				+warn_unused_function +warn_unused_record +warn_unused_vars +warnings_as_errors

TEST_ERLC_OPTS ?= +debug_info +warn_bif_clash +warn_deprecated_function +warn_deprecated_type \
				+warn_export_all +warn_export_vars +warn_shadow_vars +warn_obsolete_guard +warn_unused_import \
				+warn_unused_function +warn_unused_record +warn_unused_vars +warnings_as_errors

CT_SUITES = eunit riemann
CT_OPTS = -ct_hooks nifoc_ct_hook []

ifneq ($(USER),travis)
	CT_OPTS += -cover ./test/cover.spec
endif

EDOC_OPTS = {def, [ \
					{years, "2014"}, \
					{version, "$(PROJECT_VERSION)"} \
				]}

include erlang.mk

upload-docs: docs
	$(gen_verbose) echo $(PROJECT_VERSION)
	rsync -avz --no-o --no-g -e ssh --chmod=og=r -p --delete --exclude '*.edoc' --exclude 'edoc-info' doc/ kempkens:/var/www/nifoc/$(PROJECT)/$(PROJECT_VERSION)
	ssh kempkens chown -R www-data:www-data /var/www/nifoc/$(PROJECT)/$(PROJECT_VERSION)

.PHONY: upload-docs
