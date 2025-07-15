# 🚀 GitHub Profile Setup Instructions

## Quick Start

1. **Fork or create a new repository** with your GitHub username as the repository name (e.g., `sunny-singh-chauhan`)

2. **Clone the repository** to your local machine:
   \`\`\`bash
   git clone https://github.com/YOUR_USERNAME/YOUR_USERNAME.git
   cd YOUR_USERNAME
   \`\`\`

3. **Run the setup script**:
   \`\`\`bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   \`\`\`

4. **Update personal information**:
   - Replace all instances of `YOUR_GITHUB_USERNAME` with your actual GitHub username
   - Replace `YOUR_LEETCODE_USERNAME` with your LeetCode username
   - Update LinkedIn URL and other personal links
   - Add your portfolio URL

## Required GitHub Secrets

Go to your repository **Settings > Secrets and variables > Actions** and add:

### 🔑 Required Secrets:
- `METRICS_TOKEN`: GitHub Personal Access Token with repo permissions

### 📝 How to create GitHub Personal Access Token:
1. Go to GitHub Settings > Developer settings > Personal access tokens
2. Generate new token (classic)
3. Select scopes: `repo`, `user`, `read:org`
4. Copy the token and add it as `METRICS_TOKEN` secret

## Features Included

### ✨ Auto-updating Components:
- **GitHub Statistics**: Stars, forks, contributions
- **Recent Activity**: Latest GitHub events
- **Contribution Snake**: Animated contribution graph
- **Profile Metrics**: Detailed analytics
- **LeetCode Stats**: Problem-solving statistics

### 🛠️ Automation Scripts:
- **Repository Maintenance**: Cleanup and updates
- **Statistics Tracking**: Profile metrics collection
- **README Updates**: Dynamic content refresh
- **Contribution Tracking**: Daily activity monitoring

### 🎨 Visual Elements:
- **Typing Animation**: Dynamic introduction
- **Tech Stack Badges**: Professional skill display
- **GitHub Stats Cards**: Beautiful statistics
- **Contribution Graphs**: Activity visualization
- **Social Links**: Professional networking

## Customization

### 🎯 Personal Information:
Edit the following in `README.md`:
- Name and title
- University and CGPA
- Skills and technologies
- Project descriptions
- Contact information

### 🎨 Themes and Colors:
- GitHub stats theme: Change `theme=radical` to other themes
- Badge colors: Modify hex colors in badge URLs
- Background animations: Update GIF URLs

### 📊 Statistics:
- Add more platforms (CodeChef, HackerRank, etc.)
- Include additional metrics
- Customize activity tracking

## Maintenance

### 🔄 Automatic Updates:
- Profile updates every 6 hours
- Snake animation updates every 12 hours
- Metrics refresh daily

### 🛠️ Manual Updates:
\`\`\`bash
# Update statistics
npm run update-stats

# Run maintenance
npm run maintain

# Track recent activity
npm run track-activity

# Update README template
npm run update-readme
\`\`\`

## Troubleshooting

### Common Issues:

1. **GitHub Actions not running**:
   - Enable Actions in repository settings
   - Check if secrets are properly set

2. **Stats not updating**:
   - Verify GitHub username in all files
   - Check API rate limits

3. **Snake animation not generating**:
   - Check if contributions exist
   - Verify workflow permissions

## Support

If you encounter any issues:
1. Check the GitHub Actions logs
2. Verify all secrets are set correctly
3. Ensure your GitHub username is updated everywhere
4. Make sure repository is public (for GitHub Pages)

## Next Steps

After setup:
1. ⭐ Star this repository if it helped you!
2. 🔄 Share with friends and colleagues
3. 🎨 Customize further based on your preferences
4. 📝 Add more projects and achievements
5. 🚀 Keep coding and contributing!

---

**Happy Coding! 🚀**
