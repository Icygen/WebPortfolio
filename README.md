# Genrei G. Vargas — Web Portfolio

Professional single-page portfolio for virtual assistance, data entry, and administrative support opportunities.

## Contents

- `index.html` — Main portfolio page
- `css/style.css` — Styles
- `js/main.js` — Mobile navigation
- `assets/GenreiVargas_RESUME.pdf` — Downloadable resume

## Preview locally

Open `index.html` in your browser, or run a simple server:

```bash
# Python
python -m http.server 8080

# Node (if you have npx)
npx serve .
```

Then visit `http://localhost:8080`.

## Deploy (free)

### GitHub Pages

1. Create a GitHub repository and push this folder.
2. Go to **Settings → Pages**.
3. Source: **Deploy from branch** → `main` → `/ (root)`.
4. Your site will be at `https://<username>.github.io/<repo>/`.

### Netlify

1. Drag and drop the `WebPortfolio` folder at [netlify.com](https://www.netlify.com/).
2. Or connect your GitHub repo for automatic deploys.

## Contact form (Web3Forms)

1. Get a free access key at [web3forms.com](https://web3forms.com).
2. **GitHub (live site):** Repo → **Settings → Secrets and variables → Actions** → New secret  
   - Name: `WEB3FORMS_ACCESS_KEY`  
   - Value: your access key  
3. **Local preview:**  
   ```powershell
   copy js\form-config.example.js js\form-config.js
   ```  
   Edit `js/form-config.js` and paste your key (this file is not pushed to GitHub).
4. In Web3Forms dashboard, allow domain: `genreivargas.github.io`

## Customize

- Add a profile photo in `images/` and update the hero section in `index.html`.
- Update certification details under Education when you have dates or platform names.
- Replace `assets/GenreiVargas_RESUME.pdf` whenever you update your resume.
