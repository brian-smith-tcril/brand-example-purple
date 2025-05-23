# brand-example-purple

**This is a simple example brand package that changes the default `brand` color to purple.**

![Screenshot of the Authn MFE with this brand package enabled](./docs/images/example-with-theme.png)

## Using this brand package

> [!IMPORTANT]
> These instructions assume you have a [tutor](https://docs.tutor.edly.io/index.html) main environment set up.

### 1. Configure `tutor` to use `master-design-tokens` MFE branches

To configure `tutor` to use `master-design-tokens` MFE branches:

1. Stop `tutor` (`tutor dev stop` or `tutor local stop`)
2. Navigate to your local tutor plugins directory (`tutor plugins printroot`)
3. Create a new `use-design-tokens.py` plugin file with the following content

```py
from tutormfe.hooks import MFE_APPS

@MFE_APPS.add()
def _use_design_tokens(mfes):
    for mfe_name, mfe in mfes.items():
        mfe["version"] = "master-design-tokens"
    return mfes
```

4. Enable the plugin (`tutor plugins enable use-design-tokens`)
5. Rebuild the `tutor` MFE image (`tutor images build mfe --no-cache`)
6. Start `tutor`  (`tutor dev start lms cms mfe` or `tutor local start lms cms mfe`)

### 2. Configure `tutor` to use this theme

**This can be done in multiple ways. The CDN method does not require rebuilding the MFE image and is recommended.**

#### Using the [`jsdelivr`](https://www.jsdelivr.com/) CDN (Recommended)

1. Stop `tutor` (`tutor dev stop` or `tutor local stop`)
2. Navigate to your local tutor plugins directory (`tutor plugins printroot`)
3. Create a new `purple-jsdelivr.py` plugin file with the following content

```py
import json
from tutor import hooks

paragon_theme_urls = {
    "variants": {
        "light": {
            "urls": {
                "default": "https://cdn.jsdelivr.net/npm/@openedx/paragon@$paragonVersion/dist/light.min.css",
                "brandOverride": "https://cdn.jsdelivr.net/gh/brian-smith-tcril/brand-example-purple@bb6b7797e629c96192d0676a2cbd879b11488fa0/dist/light.min.css"
            }
        }
    }
}

fstring = f"""
MFE_CONFIG["PARAGON_THEME_URLS"] = {json.dumps(paragon_theme_urls)}
"""

hooks.Filters.ENV_PATCHES.add_item(
    (
        "mfe-lms-common-settings",
        fstring
    )
)
```

4. Enable the plugin (`tutor plugins enable purple-jsdelivr`)
5. Start `tutor`  (`tutor dev start lms cms mfe` or `tutor local start lms cms mfe`)

#### Using `npm` aliasing

1. Stop `tutor` (`tutor dev stop` or `tutor local stop`)
2. Navigate to your local tutor plugins directory (`tutor plugins printroot`)
3. Create a new `purple-npm-alias.py` plugin file with the following content

```py
from tutor import hooks

hooks.Filters.ENV_PATCHES.add_item(
    (
        "mfe-dockerfile-post-npm-install",
        """
RUN npm install '@edx/brand@github:brian-smith-tcril/brand-example-purple#174be977c9f8c7aa11591f4c6887506da72d8191'
"""
    )
)
```

4. Enable the plugin (`tutor plugins enable purple-npm-alias`)
5. Rebuild the `tutor` MFE image (`tutor images build mfe --no-cache`)
6. Start `tutor`  (`tutor dev start lms cms mfe` or `tutor local start lms cms mfe`)
