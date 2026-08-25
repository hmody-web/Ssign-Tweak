#!/usr/bin/env python3
"""
Ssign IPA patcher
- changes app display name to Ssign
- installs the provided Ssign logo into the bundle
- changes home-screen icon files to Ssign
- keeps the original Bundle ID unchanged
Usage:
  python patch_ipa.py input.ipa SsignLogo.png output.ipa
"""
import sys, os, zipfile, tempfile, shutil, plistlib
from pathlib import Path
from PIL import Image

if len(sys.argv) != 4:
    print("Usage: python patch_ipa.py input.ipa SsignLogo.png output.ipa")
    raise SystemExit(2)

ipa, logo, out = map(Path, sys.argv[1:])
work = Path(tempfile.mkdtemp(prefix="ssign_"))
try:
    with zipfile.ZipFile(ipa, "r") as z:
        z.extractall(work)

    apps = list((work / "Payload").glob("*.app"))
    if not apps:
        raise RuntimeError("No .app found in Payload")
    app = apps[0]

    info_path = app / "Info.plist"
    with open(info_path, "rb") as f:
        info = plistlib.load(f)

    info["CFBundleDisplayName"] = "Ssign"
    info["CFBundleName"] = "Ssign"

    # Use direct icon files so the new PNGs are used instead of the original asset-catalog icon.
    primary = info.setdefault("CFBundleIcons", {}).setdefault("CFBundlePrimaryIcon", {})
    primary.pop("CFBundleIconName", None)
    primary["CFBundleIconFiles"] = ["SsignIcon60"]

    ipad = info.setdefault("CFBundleIcons~ipad", {}).setdefault("CFBundlePrimaryIcon", {})
    ipad.pop("CFBundleIconName", None)
    ipad["CFBundleIconFiles"] = ["SsignIcon60", "SsignIcon76"]

    with open(info_path, "wb") as f:
        plistlib.dump(info, f, fmt=plistlib.FMT_BINARY)

    # Update localized display names when those plists exist.
    for lproj in app.glob("*.lproj"):
        p = lproj / "InfoPlist.strings"
        # Replacing localized plist safely is optional; add a minimal plist only for Arabic/English.
        if lproj.name in ("ar.lproj", "en.lproj"):
            localized = {"CFBundleDisplayName":"Ssign", "CFBundleName":"Ssign"}
            with open(p, "wb") as f:
                plistlib.dump(localized, f, fmt=plistlib.FMT_BINARY)

    im = Image.open(logo).convert("RGB")
    # In-app logo.
    im.resize((512, 512), Image.Resampling.LANCZOS).save(app / "SsignLogo.png", quality=95)

    # Home screen icon candidates.
    im.resize((120, 120), Image.Resampling.LANCZOS).save(app / "SsignIcon60@2x.png", quality=95)
    im.resize((180, 180), Image.Resampling.LANCZOS).save(app / "SsignIcon60@3x.png", quality=95)
    im.resize((152, 152), Image.Resampling.LANCZOS).save(app / "SsignIcon76@2x~ipad.png", quality=95)

    # Also replace the app's own visible logos so old branding is reduced.
    for name in ("ESignLogo.png", "ESignDebugLogo.png", "EFileLogo.png"):
        target = app / name
        if target.exists():
            im.resize((512, 512), Image.Resampling.LANCZOS).save(target, quality=95)

    # Old signature must be discarded; the IPA will be re-signed afterward.
    sig = app / "_CodeSignature"
    if sig.exists():
        shutil.rmtree(sig)

    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
        for p in work.rglob("*"):
            if p.is_file():
                z.write(p, p.relative_to(work))
    print(f"Created: {out}")
    print("Next: inject SsignTheme.dylib, then sign the resulting IPA with your certificate/profile.")
finally:
    shutil.rmtree(work, ignore_errors=True)
