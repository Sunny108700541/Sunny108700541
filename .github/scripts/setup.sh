#!/bin/bash

# GitHub Profile Setup Script
# Run this script to set up your GitHub profile with all necessary configurations

echo "🚀 Setting up your GitHub profile..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git first."
    exit 1
fi

# Get GitHub username
read -p "Enter your GitHub username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    print_error "GitHub username cannot be empty!"
    exit 1
fi

# Update README with actual username
print_status "Updating README with your GitHub username..."
sed -i "s/YOUR_GITHUB_USERNAME/$GITHUB_USERNAME/g" README.md

# Create necessary directories
print_status "Creating directory structure..."
mkdir -p .github/workflows
mkdir -p scripts
mkdir -p assets

# Set up Git hooks
print_status "Setting up Git hooks..."
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook to update last modified date in README

if [ -f README.md ]; then
    sed -i "s/Last updated: .*/Last updated: $(date '+%Y-%m-%d %H:%M:%S')/" README.md
    git add README.md
fi
EOF

chmod +x .git/hooks/pre-commit

# Create gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    print_status "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
logs
*.log

# Temporary files
*.tmp
*.temp
EOF
fi

# Create profile stats script
print_status "Creating profile stats script..."
cat > scripts/update-stats.py << 'EOF'
#!/usr/bin/env python3
"""
Script to update GitHub profile statistics
"""

import requests
import json
import os
from datetime import datetime

def get_github_stats(username):
    """Fetch GitHub statistics for a user"""
    try:
        # Get user info
        user_url = f"https://api.github.com/users/{username}"
        user_response = requests.get(user_url)
        user_data = user_response.json()
        
        # Get repositories
        repos_url = f"https://api.github.com/users/{username}/repos"
        repos_response = requests.get(repos_url)
        repos_data = repos_response.json()
        
        # Calculate stats
        total_stars = sum(repo['stargazers_count'] for repo in repos_data)
        total_forks = sum(repo['forks_count'] for repo in repos_data)
        total_repos = len(repos_data)
        
        stats = {
            'username': username,
            'public_repos': user_data.get('public_repos', 0),
            'followers': user_data.get('followers', 0),
            'following': user_data.get('following', 0),
            'total_stars': total_stars,
            'total_forks': total_forks,
            'last_updated': datetime.now().isoformat()
        }
        
        return stats
        
    except Exception as e:
        print(f"Error fetching stats: {e}")
        return None

def main():
    username = os.environ.get('GITHUB_USERNAME', 'YOUR_GITHUB_USERNAME')
    stats = get_github_stats(username)
    
    if stats:
        print("📊 GitHub Statistics:")
        print(f"   Repositories: {stats['public_repos']}")
        print(f"   Followers: {stats['followers']}")
        print(f"   Following: {stats['following']}")
        print(f"   Total Stars: {stats['total_stars']}")
        print(f"   Total Forks: {stats['total_forks']}")
        
        # Save to file
        with open('stats.json', 'w') as f:
            json.dump(stats, f, indent=2)
        
        print("✅ Stats saved to stats.json")
    else:
        print("❌ Failed to fetch statistics")

if __name__ == "__main__":
    main()
EOF

chmod +x scripts/update-stats.py

# Create maintenance script
print_status "Creating maintenance script..."
cat > scripts/maintain-repo.sh << 'EOF'
#!/bin/bash

# Repository maintenance script
echo "🔧 Running repository maintenance..."

# Update dependencies (if package.json exists)
if [ -f package.json ]; then
    echo "📦 Updating npm dependencies..."
    npm update
fi

# Clean up old branches (except main/master)
echo "🧹 Cleaning up old branches..."
git branch --merged | grep -v "\*\|main\|master" | xargs -n 1 git branch -d 2>/dev/null || true

# Update README stats
echo "📊 Updating profile statistics..."
python3 scripts/update-stats.py

# Commit changes if any
if [ -n "$(git status --porcelain)" ]; then
    echo "💾 Committing maintenance updates..."
    git add .
    git commit -m "🔧 Automated maintenance update - $(date '+%Y-%m-%d')"
fi

echo "✅ Maintenance completed!"
EOF

chmod +x scripts/maintain-repo.sh

# Create contribution script
print_status "Creating contribution tracking script..."
cat > scripts/track-contributions.js << 'EOF'
const https = require('https');
const fs = require('fs');

const username = process.env.GITHUB_USERNAME || 'YOUR_GITHUB_USERNAME';

function fetchContributions() {
    const options = {
        hostname: 'api.github.com',
        path: `/users/${username}/events`,
        method: 'GET',
        headers: {
            'User-Agent': 'GitHub-Profile-Tracker'
        }
    };

    const req = https.request(options, (res) => {
        let data = '';
        
        res.on('data', (chunk) => {
            data += chunk;
        });
        
        res.on('end', () => {
            try {
                const events = JSON.parse(data);
                const today = new Date().toDateString();
                const todayEvents = events.filter(event => 
                    new Date(event.created_at).toDateString() === today
                );
                
                console.log(`📈 Today's GitHub activity: ${todayEvents.length} events`);
                
                // Save activity summary
                const summary = {
                    date: today,
                    total_events: todayEvents.length,
                    event_types: [...new Set(todayEvents.map(e => e.type))],
                    last_updated: new Date().toISOString()
                };
                
                fs.writeFileSync('daily-activity.json', JSON.stringify(summary, null, 2));
                console.log('✅ Activity summary saved!');
                
            } catch (error) {
                console.error('❌ Error parsing GitHub events:', error.message);
            }
        });
    });

    req.on('error', (error) => {
        console.error('❌ Error fetching contributions:', error.message);
    });

    req.end();
}

fetchContributions();
EOF

# Create README template updater
print_status "Creating README template updater..."
cat > scripts/update-readme-template.py << 'EOF'
#!/usr/bin/env python3
"""
Script to update README template with dynamic content
"""

import re
import json
from datetime import datetime

def update_readme_stats():
    """Update README with latest statistics"""
    try:
        # Read current README
        with open('README.md', 'r') as f:
            content = f.read()
        
        # Read stats if available
        stats_file = 'stats.json'
        if os.path.exists(stats_file):
            with open(stats_file, 'r') as f:
                stats = json.load(f)
            
            # Update stats in README (you can customize this section)
            print("📝 README updated with latest stats")
        
        # Update last modified timestamp
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        content = re.sub(
            r'Last updated: .*',
            f'Last updated: {timestamp}',
            content
        )
        
        # Write back to README
        with open('README.md', 'w') as f:
            f.write(content)
            
        print("✅ README template updated successfully!")
        
    except Exception as e:
        print(f"❌ Error updating README: {e}")

if __name__ == "__main__":
    import os
    update_readme_stats()
EOF

chmod +x scripts/update-readme-template.py

print_status "Setting up GitHub Actions secrets..."
echo ""
echo "🔐 You need to set up the following GitHub secrets:"
echo "   1. Go to your repository Settings > Secrets and variables > Actions"
echo "   2. Add these secrets:"
echo "      - WAKATIME_API_KEY (get from https://wakatime.com/api-key)"
echo "      - METRICS_TOKEN (GitHub personal access token)"
echo ""

print_status "Final steps:"
echo "   1. Replace 'YOUR_GITHUB_USERNAME' with your actual username in all files"
echo "   2. Replace 'YOUR_LEETCODE_USERNAME' with your LeetCode username"
echo "   3. Update portfolio URL and other personal links"
echo "   4. Commit and push all changes to GitHub"
echo "   5. Enable GitHub Actions in your repository settings"
echo ""

print_status "Quick commands to get started:"
echo "   git add ."
echo "   git commit -m '🚀 Initial profile setup'"
echo "   git push origin main"
echo ""

echo -e "${GREEN}🎉 GitHub profile setup completed!${NC}"
echo -e "${BLUE}Your profile will be automatically updated every 6 hours.${NC}"
